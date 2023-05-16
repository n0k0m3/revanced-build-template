# Revanced Build
This repo template will allow you to build ReVanced using Github Actions. This will helps people who don't want to setup build environments on their machines.

## Notes
- The script will download the **selected compatible version**([see here](versions.json)) of Youtube on APKMirror, **NOT** latest official version on Google Play.
- Under **NO CIRCUMSTANCES** any APKs will be uploaded to this repository to avoid DMCA.

## How to setup
1. Fork or create a new repository using this repository as a template ([Guide](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template)). DO NOT FORK if you need to set the new repo to private.
2. That's it! You can now build ReVanced using Github Actions.

## Customize your build
If you wish to continue with the default settings, you may skip this step.

All supported ReVanced apps are built by default by the script. If you wish to modify this behaviour and build only the apps that you specify, edit the 'build.targets' file with your preferred text editor. For the apps that you wish to be built, set the value of variable associated with the app to "true". Any variable with a value that is not "true" will be skip the associated app from being built.

For example, if you wish to skip TikTok ReVanced from being built, change the value of TIKTOK_NONROOT to "false".

By default this will build ReVanced apps with ALL available patches. Follow [this guide](PATCHES_GUIDE.md) to exclude/customizing patches for your build.

The script also supports using patches from Inotia00's ReVanced Extended project. To enable support for this, set "EXTENDED_SUPPORT" to "true" in build.config. Bear in mind that this will also disable builds for apps other than YouTube and YouTube Music regardless of what value you've assigned. This is due to the fact that ReVanced Extended does not (yet) support apps other than the ones specified above.

## How to build
1. Go to Actions -> All workflows -> ReVanced Build ([Example](images/workflow_run.png))
2. Run the `build` workflow (try to use `experimental_build` if the logs show not all patches applied correctly while revanced is not yet released)
3. Download the APKs from the draft releases ([Example](images/build_release.png))
