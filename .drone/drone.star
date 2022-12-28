def _pipeline(ctx, pkgname, event_triggers, distro_codename, docker_image):
    branch = ctx.build.branch
    volume_path = "/mnt/prebuilt-mpr/" + pkgname + "/" + distro_codename

    return [
        {
            "name": distro_codename + "-build",
            "kind": "pipeline",
            "type": "docker",
            "trigger": {
                "event": event_triggers,
                "branch": ["pkg/*"]
            },
            "volumes": [{"name": "pkgdir", "host": {"path": volume_path}}],
            "node": {"server": "prebuilt-mpr"},
            "steps": [{
                "name": "build",
                "image": docker_image,
                "failure": "ignore",
                "pull": "always",
                "environment": {
                    "distro_codename": distro_codename,
                    "LANG": "en_US.UTF-8"
                },
    	        "volumes": [{
                    "name": "pkgdir",
                    "path": volume_path
                }],
                "commands": [".drone/scripts/build.sh"]
            }]
        },

        {
            "name": distro_codename + "-publish",
            "kind": "pipeline",
            "type": "docker",
            "trigger": {
                "event": event_triggers,
                "branch": ["pkg/*"]
            },
            "depends_on": [distro_codename + "-build"],
            "volumes": [{"name": "pkgdir", "host": {"path": volume_path}}],
            "node": {"server": "prebuilt-mpr"},
            "steps": [{
                "name": "publish",
                "image": docker_image,
                "pull": "always",
                "environment": {
                    "proget_api_key": {"from_secret": "proget_api_key"},
                    "distro_codename": distro_codename
                },
		"volumes": [{
                    "name": "pkgdir",
                    "path": volume_path
                }],
                "commands": [
                    "sudo apt install python3 python3-apt python3-requests -y",
		    ".drone/scripts/publish.py"
                ]
            }]
        },

	{
	    "name": distro_codename + "-cleanup",
            "kind": "pipeline",
            "type": "docker",
            "trigger": {
                "event": event_triggers,
                "branch": ["pkg/*"],
		"status": ["success", "failure"]
            },
            "depends_on": [distro_codename + "-publish"],
            "volumes": [{"name": "pkgdir", "host": {"path": volume_path}}],
            "node": {"server": "prebuilt-mpr"},
            "steps": [{
                "name": "cleanup",
                "image": docker_image,
                "pull": "always",
                "environment": {
                    "proget_api_key": {"from_secret": "proget_api_key"},
                    "distro_codename": distro_codename
                },
		"volumes": [{
                    "name": "pkgdir",
                    "path": volume_path
                }],
                "commands": ["find " + volume_path + " -mindepth 1 -maxdepth 1 -exec sudo rm -rfv {} +"]
            }]
	}
    ]

def main(ctx):
    pkgname = ctx.build.branch.replace("pkg/", "")

    # A list of distros to build for.
    distros = {
        "focal": "ubuntu-focal",
        "jammy": "ubuntu-jammy",
	"kinetic": "ubuntu-kinetic",
        "bullseye": "debian-bullseye"
    }

    # A list of packages that should only have one build ran at a time.
    singular_builds = [
        "deno",
	"matrix-commander-rs",
        "rustc"
    ]
    
    # If the package ends in '-git' we want to build it nightly via Drone CI cron jobs.
    event_triggers = ["push", "custom"]
    if ctx.build.branch.endswith("-git"):
        event_triggers += ["cron"]

    # Get the JSON object to return.
    output = []
    for distro, image in distros.items():
        output += _pipeline(ctx, pkgname, event_triggers, distro, "proget.makedeb.org/docker/makedeb/makedeb:" + image)

    output += [{
            "name": "set-build-status",
            "kind": "pipeline",
            "type": "docker",
            "trigger": {
                "event": event_triggers,
                "branch": ["pkg/*"]
            },
            "depends_on": [distro + "-cleanup" for distro in distros],
            "steps": [{
                "name": "set-build-status",
                "image": "ubuntu",
                "pull": "always",
                "commands": [
                    "apt update",
                    "apt install python3 python3-requests -y",
                    ".drone/scripts/set-build-status.py"
                ]
            }]
        }]

    # If we only want to run a single build at a time, make each `-build` stage depend on the `-cleanup` stage before it.
    if pkgname in singular_builds:
        for (index, item) in enumerate(output[3::]):
            if item["name"].endswith("-build") == False:
                continue

            # Get the actual index position since we don't start at the beginning. 
            position = index + 3
            
            output[position]["depends_on"] = [output[position - 1]["name"]]

    return output
