# Prebuilt-MPR v2
This is the source for the code that powers the Prebuilt-MPR. Here lies the needed components that allow for continuous deployments of MPR packages to the Prebuilt-MPR APT repositories.

## The Prebuilt-MPR update flow
A few things happen from a package being upload to the MPR to the package making it to the Prebuilt-MPR's APT repositories. We'll use the [Hugo](https://mpr.makedeb.org/packages/hugo) package as an example.

1. Hugo gets updated on the MPR.
2. The Prebuilt-MPR [updater](/updater) checks for current package versions, and notices that Hugo isn't up to date in the Prebuilt-MPR repository.
3. The updater creates a pull request with the updated version stored in [`packages/hugo`](/packages/hugo).
4. The pull request gets merged, which triggers another automated script that creates a deployment job for Hugo on the `pkg/hugo` branch in this repository.
5. Assuming all goes well, Hugo is built in the Prebuilt-MPR's CI system, and is deployed to the APT repositories to be downloaded by end users.

## Security
Since you're downloading pre-compiled packages when using the Prebuilt-MPR, you run the risk of installing malware (and more so since there is no way to inspect source files like you could on the MPR).

The Prebuilt-MPR solves this by requiring a [makedeb Trusted User](https://docs.makedeb.org/support/makedeb-team/) to merge each pull request. This ensures that any files that you install onto your system will already have been reviewed before installation.

The MPR platform itself is also crucial to this system. Every time a user pushes to the MPR, the MPR automatically creates a tag for the package's version. This tag is not allowed to be updated, ensuring that if you pull the tag you'll always pull a specific commit.

This all combines to create a secure and easy-to-use method for installing MPR packages in environments where building from source might not be ideal.
