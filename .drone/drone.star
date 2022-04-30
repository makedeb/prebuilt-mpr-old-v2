def _pipeline(ctx, distro_codename, docker_image):
    event_triggers = ["push", "custom"]
    branch = ctx.build.branch
    pkgname = branch.replace("pkg/", "")

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
            "volumes": [{"name": "pkgdir", "host": {"path": "/var/tmp/prebuilt-mpr/" + pkgname}}],
            "node": {"server": "prebuilt-mpr"},
            "steps": [{
                "name": "build",
                "image": docker_image,
                "pull": "always",
    	        "volumes": [{
                    "name": "pkgdir",
                    "path": "/var/tmp/prebuilt-mpr/" + pkgname
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
            "volumes": [{"name": "pkgdir", "host": {"path": "/var/tmp/prebuilt-mpr/" + pkgname}}],
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
                    "path": "/tmp/prebuilt-mpr"
                }],
                "commands": [
                    "sudo apt install python3 python3-apt python3-requests -y",
		    ".drone/scripts/publish.py"
                ]
            }]
        }
    ]

def main(ctx):
    return (
        _pipeline(ctx, "focal", "proget.hunterwittenborn.com/docker/makedeb/makedeb:ubuntu-focal") +
        _pipeline(ctx, "bullseye", "proget.hunterwittenborn.com/docker/makedeb/makedeb:debian-bullseye")
    )
