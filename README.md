# Revanced Build
This repo template will allow you to build ReVanced using Github Actions. This will helps people who don't want to setup build environments on their machines.

## Notes
- Current implementation cannot download the latest compatible versions of Youtube and Youtube Music, as APKPure either doesn't have bundled APK, or doesn't have older versions of the apps that are compatible with ReVanced.
- Under NO CIRCUMSTANCES any APKs will be uploaded to this repository to avoid DMCA.

## How to use
1. Create a new repository using this repository as a template ([Guide](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template)). DO NOT FORK UNLESS YOU WANT TO CONTRIBUTE TO THE REPOSITORY. Set the new repo to private if needed.
2. Download latest (compatible) APKs of Youtube and Youtube Music from APKMirror.com:
- [Youtube 17.22.36](https://www.apkmirror.com/apk/google-inc/youtube/youtube-17-22-36-release/youtube-17-22-36-2-android-apk-download/)
  - Rename to `com.google.android.youtube.apk`
- [Youtube Music 5.03.50](https://www.apkmirror.com/apk/google-inc/youtube-music/youtube-music-5-03-50-release/)
  - Choose correct version according to your device architecture
  - Rename to `com.google.android.apps.youtube.music.apk`
3. Upload APKs to the repository via `Add file -> Upload files`
4. Go to Actions...


