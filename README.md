# Revanced Build
This repo template will allow you to build ReVanced using Github Actions. This will helps people who don't want to setup build environments on their machines.
By default this will build ReVanced with ALL available patches. You can modify the `build_revanced.sh` script to limit to only patches you want to use.

## Notes
- Current implementation cannot download the latest compatible versions of Youtube and Youtube Music, as APKPure either doesn't have bundled APK, or doesn't have older versions of the apps that are compatible with ReVanced.
- While this template will build Revanced Music Non-root, it won't work as current patches doesn't include the Music Non-root (microG) patch (track [this commit](https://github.com/revanced/revanced-patches/commit/e22060b52cf09b5b6fe08d5b9ffb8f102efc6cf5) when it will get merged to `main` and released). Don't open an issue here. Just rebuild ReVanced when music microG patch is available on [ReVanced Patches](https://github.com/revanced/revanced-patches/releases).
- Under NO CIRCUMSTANCES any APKs will be uploaded to this repository to avoid DMCA.

## How to setup
1. Create a new repository using this repository as a template ([Guide](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template)). DO NOT FORK UNLESS YOU WANT TO CONTRIBUTE TO THE REPOSITORY. Set the new repo to private if needed.
2. Download latest (compatible) APKs of Youtube and Youtube Music from APKMirror.com:
   - [Youtube 17.22.36](https://www.apkmirror.com/apk/google-inc/youtube/youtube-17-22-36-release/youtube-17-22-36-2-android-apk-download/)
     - Rename to `com.google.android.youtube.apk`
   - [Youtube Music 5.03.50](https://www.apkmirror.com/apk/google-inc/youtube-music/youtube-music-5-03-50-release/)
     - Choose correct version according to your device architecture
     - Rename to `com.google.android.apps.youtube.music.apk`
3. Publish a new release under tag `base` and upload the APKs to the release. ([Step 1](images/release_1.png), [Step 2](images/release_2.png))

## How to build
1. Go to Actions -> All workflows -> ReVanced Build ([Example](images/workflow_run.png))
2. Run the workflow
3. Download the APKs from the draft releases ([Example](images/build_release.png))


