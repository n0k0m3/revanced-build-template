# Revanced Build
This repo template will allow you to build ReVanced using Github Actions. This will helps people who don't want to setup build environments on their machines.

## Notes
- The script will download the version that's mentioned in versions.json of Youtube and Youtube Music from ApkMirror, **NOT** latest official version on Google Play.
- Under **NO CIRCUMSTANCES** any APKs will be uploaded to this repository to avoid DMCA.

## How to setup
1. Fork or create a new repository using this repository as a template ([Guide](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template)). DO NOT FORK if you need to set the new repo to private.
2. That's it! You can now build ReVanced using Github Actions.

## Customize your build
If you wish to continue with the default settings, you may skip this step.

By default this will build ReVanced with ALL available patches. Follow [this guide](PATCHES_GUIDE.md) to exclude/customizing patches for your build.

## How to build
1. Go to Actions -> All workflows -> ReVanced Build ([Example](images/workflow_run.png))
2. Run the `build` workflow (try to use `experimental_build` if the logs show not all patches applied correctly while revanced is not yet released)
3. Download the APKs from the draft releases ([Example](images/build_release.png))
