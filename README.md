# Revanced Build
This repo template will allow you to build ReVanced using Github Actions. This will helps people who don't want to setup build environments on their machines.
By default this will build ReVanced with ALL available patches. Follow [this guide](PATCHES_GUIDE.md) to exclude/customizing patches for your build.

## Notes
~~-Current implementation cannot download the latest compatible versions of Youtube and Youtube Music, as APKPure either doesn't have bundled APK, or doesn't have older versions of the apps that are compatible with ReVanced.~~
- While this template will build Revanced Music Non-root, it won't work as current patches doesn't include the Music Non-root (microG) patch (track [this PR](https://github.com/revanced/revanced-patches/pull/22) when it will get merged to `main` and released). Don't open an issue here. Just rebuild ReVanced when music microG patch is available on [ReVanced Patches](https://github.com/revanced/revanced-patches/releases).
- Under NO CIRCUMSTANCES any APKs will be uploaded to this repository to avoid DMCA.

## How to setup
1. Fork or create a new repository using this repository as a template ([Guide](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template)). DO NOT FORK if you need to set the new repo to private.
2. That's it! You can now build ReVanced using Github Actions.
<s>
2. Download latest (compatible) APKs of Youtube and Youtube Music from APKMirror.com:
   - [Youtube 17.26.35](https://www.apkmirror.com/apk/google-inc/youtube/youtube-17-26-35-release/youtube-17-26-35-android-apk-download/)
     - Rename to `com.google.android.youtube.apk`
   - [Youtube Music 5.03.50](https://www.apkmirror.com/apk/google-inc/youtube-music/youtube-music-5-03-50-release/)
     - Choose correct version according to your device architecture
     - Rename to `com.google.android.apps.youtube.music.apk`
3. Publish a new release under tag `base` and upload the APKs to the release. ([Step 1](images/release_1.png), [Step 2](images/release_2.png))
</s>

## How to build
1. Go to Actions -> All workflows -> ReVanced Build ([Example](images/workflow_run.png))
2. Run the `build` workflow (try to use `experimental_build` if the logs show not all patches applied correctly while revanced is not yet released)
3. Download the APKs from the draft releases ([Example](images/build_release.png))
