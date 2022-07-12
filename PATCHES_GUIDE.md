# Customizing ReVanced Builds

**Please read the following information before beginning.**

By default the script will build ReVanced with ALL available patches. Edit `patches.txt` to customize your build of ReVanced.

## !IMPORTANT!
1. Each patch name MUST start from a NEWLINE AND there should be only ONE patch PER LINE
2. DO NOT add any other type of symbol or character, it will break the script! You have been warned!
3. Anything starting with a hash (`#`) will be ignored. Also, do not add hash or any other character after a patch's name
4. Both YT Music ReVanced & YT ReVanced are supported
5. Patches are EXCLUSION, by default all patches will be included in the build.
6. DO NOT add `microg-patch` to the list of patches.

## Example
Example content of `patches.txt`:

- Exclude pure black theme and keep `create` button:
```
amoled
disable-create-button
```

- Exclude patches for both Music & YouTube (order doesn't matter)
```
amoled
exclusive-background-playback
disable-create-button
premium-heading
tasteBuilder-remover
```

## List of Available Patches
NOTE: List of all patches is given below. Only take the NAME i.e, the string BEFORE `:` (colon)
NOTE2: DO NOT add `microg-patch` here, it is only required for root variant & is hardcoded in the script

List of all available patches obtained from: `revanced-patches-2.9.2`

Synopsis: `NAME: Description`

**YT ReVanced Specific Patches**
```
swipe-controls: Adds volume and brightness swipe controls.
seekbar-tapping: Enable tapping on the seekbar of the YouTube player.
general-ads: Patch to remove general ads in bytecode.
video-ads: Patch to remove ads in the YouTube video player.
hide-infocard-suggestions: Hides infocards in videos.
autorepeat-by-default: Enables auto repeating of videos by default.
custom-branding: Change the branding of YouTube.
premium-heading: Show the premium branding on the the YouTube home screen.
minimized-playback: Enable minimized and background playback.
enable-wide-searchbar: Replaces the search icon with a wide search bar. This will hide the YouTube logo when active.
disable-fullscreen-panels: Disable comments panel in fullscreen view.
old-quality-layout: Enable the original quality flyout menu.
hide-autoplay-button: Disable the autoplay button.
disable-create-button: Disable the create button.
amoled: Enables pure black theme.
hide-shorts-button: Hide the shorts button.
hide-cast-button: Patch to hide the cast button.
hide-watermark: Hide the creator's watermark on video's
custom-playback-speed: Allows to change the default playback speed options.
hdr-max-brightness: Set brightness to max for HDR videos in fullscreen mode.
```

**YT Music ReVanced Specific Patches**
```
background-play: Enable playing music in the background.
exclusive-audio-playback: Add the option to play music without video.
codecs-unlock: Enables more audio codecs. Usually results in better audio quality but may depend on song and device.
upgrade-button-remover: Remove the upgrade tab from the pivot bar in YouTube music.
tasteBuilder-remover: Removes the "Tell us which artists you like" card from the Home screen. The same functionality can be triggered from the settings anyway.
```

**General Patches**
```
enable-debugging: Enable app debugging by patching the manifest file
```
