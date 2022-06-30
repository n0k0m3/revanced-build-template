#!/bin/bash

# Latest compatible version of apks
# YouTube Music 5.03.50
# YouTube 17.25.34
# Vanced microG 0.2.24.220220

YTM_VERSION="5.03.50"
YT_VERSION="17.25.34"
VMG_VERSION="0.2.24.220220"

# Artifacts associative array aka dictionary
declare -A artifacts

artifacts["revanced-cli.jar"]="revanced/revanced-cli revanced-cli .jar"
artifacts["revanced-integrations.apk"]="revanced/revanced-integrations app-release-unsigned .apk"
artifacts["revanced-patches.jar"]="revanced/revanced-patches revanced-patches .jar"
artifacts["apkeep"]="EFForg/apkeep apkeep-x86_64-unknown-linux-gnu"

get_artifact_download_url () {
    # Usage: get_download_url <repo_name> <artifact_name> <file_type>
    local api_url="https://api.github.com/repos/$1/releases/latest"
    local result=$(curl $api_url | jq ".assets[] | select(.name | contains(\"$2\") and contains(\"$3\") and (contains(\".sig\") | not)) | .browser_download_url")
    echo ${result:1:-1}
}

# Fetch all the dependencies
for artifact in "${!artifacts[@]}"; do
    if [ ! -f $artifact ]; then
        echo "Downloading $artifact"
        curl -L -o $artifact $(get_artifact_download_url ${artifacts[$artifact]})
    fi
done

# Fetch microG
chmod +x apkeep

# ./apkeep -a com.google.android.youtube@17.25.34 com.google.android.youtube
# ./apkeep -a com.google.android.apps.youtube.music@5.03.50 com.google.android.apps.youtube.music

if [ ! -f "vanced-microG.apk" ]; then
    echo "Downloading Vanced microG"
    ./apkeep -a com.mgoogle.android.gms@$VMG_VERSION .
    mv com.mgoogle.android.gms@$VMG_VERSION.apk vanced-microG.apk
fi

# if [ -f "com.google.android.youtube.xapk" ]
# then
#     unzip com.google.android.youtube.xapk -d youtube
#     yt_apk_path="youtube/com.google.android.youtube.apk"
# elif [ -f "com.google.android.youtube.apk" ]
# then
#     yt_apk_path="com.google.android.youtube.apk"
# else
#     echo "Cannot find APK"
# fi

echo "************************************"
echo "Building YouTube APK"
echo "************************************"

mkdir -p build
# All patches will be included by default, you can exclude patches by appending -e patch-name to exclude said patch.
# Example: -e microg-support

# All available patches obtained from: revanced-patches-2.4.0

# seekbar-tapping: Enable tapping on the seekbar of the YouTube player. 
# general-ads: Patch to remove general ads in bytecode. 
# video-ads: Patch to remove ads in the YouTube video player. 
# custom-branding: Change the branding of YouTube. 
# premium-heading: Show the premium branding on the the YouTube home screen. 
# minimized-playback: Enable minimized and background playback. 
# disable-fullscreen-panels: Disable comments panel in fullscreen view. 
# old-quality-layout: Enable the original quality flyout menu. 
# hide-autoplay-button: Disable the autoplay button. 
# disable-create-button: Disable the create button. 
# amoled: Enables pure black theme. 
# hide-shorts-button: Hide the shorts button. 
# hide-cast-button: Patch to hide the cast button. 
# hide-watermark: Hide Watermark on the page. 
# microg-support: Patch to allow YouTube ReVanced to run without root and under a different package name. 
# custom-playback-speed: Allows to change the default playback speed options. 
# background-play: Enable playing music in the background. 
# exclusive-audio-playback: Add the option to play music without video. 
# codecs-unlock: Enables more audio codecs. Usually results in better audio quality but may depend on song and device. 
# upgrade-button-remover: Remove the upgrade tab from the pivot bar in YouTube music. 
# tasteBuilder-remover: Removes the "Tell us which artists you like" card from the Home screen. The same functionality can be triggered from the settings anyway. 

if [ -f "com.google.android.youtube.apk" ]
then
    echo "Building Root APK"
    java -jar revanced-cli.jar -m revanced-integrations.apk -b revanced-patches.jar --mount \
                               -e microg-support \
                               -a com.google.android.youtube.apk -o build/revanced-root.apk
    echo "Building Non-root APK"
    java -jar revanced-cli.jar -m revanced-integrations.apk -b revanced-patches.jar  \
                               -a com.google.android.youtube.apk -o build/revanced-nonroot.apk
else
    echo "Cannot find YouTube APK, skipping build"
fi
echo ""
echo "************************************"
echo "Building YouTube Music APK"
echo "************************************"
if [ -f "com.google.android.apps.youtube.music.apk" ]
then
    echo "Building Root APK"
    java -jar revanced-cli.jar -b revanced-patches.jar --mount \
                               -e microg-support \
                               -a com.google.android.apps.youtube.music.apk -o build/revanced-music-root.apk
    echo "Building Non-root APK"
    java -jar revanced-cli.jar -b revanced-patches.jar \
                               -a com.google.android.apps.youtube.music.apk -o build/revanced-music-nonroot.apk
else
    echo "Cannot find YouTube Music APK, skipping build"
fi
