def main(ctx):
    return {
        "name": "build-and-deploy",
        "kind": "pipeline",
        "type": "exec",
        "node": {"server": "homelab"},
        "steps": [
            {
                "name": "build",
                "environment": {
                    "proget_api_key": {"from_secret": "proget_api_key"}
                },
                "commands": [".drone/scripts/build.sh"]
            },
            {
                "name": "deploy",
	        "environment": {
	    	    "prebuilt_mpr_github_api_token": {"from_secret": "prebuilt_mpr_github_api_token"}
	        },
                "commands": [".drone/scripts/deploy.sh"]
            }
        ]
    }
