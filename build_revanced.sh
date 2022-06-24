#!/bin/bash

# Latest compatible version of apks
# YouTube Music 5.03.50
# YouTube 17.24.34
# Vanced microG 0.2.24.220220

YTM_VERSION="5.03.50"
YT_VERSION="17.24.34"
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

# ./apkeep -a com.google.android.youtube@17.24.34 com.google.android.youtube
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
# Obtained from: revanced-patches-1.9.1
# available_patches="-e amoled -e minimized-playback -e disable-create-button -e premium-heading -e custom-branding -e disable-shorts-button -e disable-fullscreen-panels -e old-quality-layout -e hide-cast-button -e microg-support -e general-ads -e video-ads -e seekbar-tapping -e upgrade-button-remover -e tasteBuilder-remover -e background-play -e exclusive-audio-playback -e codecs-unlock"

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
