def _pipeline(ctx, distro_codename, docker_image):
    event_triggers = ["push", "custom"]
    branch = ctx.build.branch
    pkgname = branch.replace("pkg/", "")
    volume_path = "/var/tmp/prebuilt-mpr/" + pkgname + "/" + distro_codename

    if branch.endswith("-git"):
        event_triggers += ["cron"]

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
                "pull": "always",
                "environment": {
                    "distro_codename": distro_codename
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
                "commands": ["find " + volume_path + " -mindepth 1 -maxdepth 1 -exec sudo rm -rfv {} +"]
            }]
	}
    ]

def main(ctx):
    return (
        _pipeline(ctx, "focal", "proget.hunterwittenborn.com/docker/makedeb/makedeb:ubuntu-focal") +
        _pipeline(ctx, "bullseye", "proget.hunterwittenborn.com/docker/makedeb/makedeb:debian-bullseye")
    )
