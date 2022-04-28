def main(ctx):
    if "pkg-update" in ctx.build.message:
        build_name = "deploy-package"
        steps = [{
            "name": build_name,
            "image": "ubuntu:focal",
            "environment": {
                "ssh_key": {"from_secret": "ssh_key"}
            },
            "commands": [".drone/scripts/deploy-package.sh"]
        }]
    else:
        build_name = "deploy-image"
        steps = [{
            "name": build_name,
            "image": "ubuntu:focal",
            "commands": [".drone/scripts/deploy-image.sh"]
        }]

    return {
        "name": build_name,
        "kind": "pipeline",
        "type": "docker",
        "steps": steps
    }
