# Prebuilt-MPR v2
This is the source for the code that powers the Prebuilt-MPR. Here lies the needed components that allow for continuous deployments of MPR packages to the Prebuilt-MPR APT repositories.

## The Prebuilt-MPR update flow
A few things happen from a package being upload to the MPR to the package making it to the Prebuilt-MPR's APT repositories. We'll use the [`archlinux-wallpaper`](https://mpr.makedeb.org/packages/archlinux-wallpaper) package as an example.

1. `archlinux-wallpaper` gets updated on the MPR.
2. The Prebuilt-MPR [updater](/main.py) noticices that the package is out of date, and creates a pull request to update the package's version in the Prebuilt-MPR.
3. The pull request gets merged, triggering a CI job to build and deploy the package.

And assuming all goes sound, you then get the new version of the package ready to be installed on your system!

## Security
Since you're downloading pre-compiled packages when using the Prebuilt-MPR, you run the risk of installing malware (and more so since there is no way to inspect source files like you could on the MPR).

The Prebuilt-MPR solves this by hosting a separate copy of each package in this repo on the `pkg/` branches. Since updates are done via pull requests, it allows a [makedeb Trusted User](https://docs.makedeb.org/support/makedeb-team) to review the build files before they get merged and deployed into the Prebuilt-MPR APT repository.
