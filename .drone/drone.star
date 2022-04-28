def _pipeline(ctx, docker_image):
    event_triggers = ["push", "custom"]
    branch = ctx.build.branch

    if branch.endswith("-git"):
        event_triggers += ["cron"]

    return {
        "name": branch.replace("pkg/", ""),
        "kind": "pipeline",
        "type": "docker",
        "trigger": {
            "event": event_triggers,
            "branch": ["pkg/*"]
        },
        "node": {"server": "prebuilt-mpr"},
        "steps": [
            {
                "name": "build",
                "image": docker_image,
                "environment": {
                    "version": "1.6.1-1"
                },
                "commands": [".drone/scripts/build.sh"]
            },
            {
                "name": "publish",
                "image": docker_image,
                "commands": [
                    "sudo apt install python3 python3-apt python3-requests -y",
		    ".drone/scripts/publish.py"
                ]
            }
        ]
    }

def main(ctx):
    return _pipeline(ctx, "proget.hunterwittenborn.com/docker/makedeb/makedeb:ubuntu-focal")
