#!/bin/bash

get_artifact_download_url () {
    # Usage: get_download_url <repo_name> <artifact_name> <file_type>
    local api_url="https://api.github.com/repos/$1/releases/latest"
    local result=($(curl $api_url | jq ".assets[] | select(.name | contains(\"$2\") and contains(\"$3\")) | .browser_download_url"))
    echo $result
}

CLI_URL=$(get_artifact_download_url "revanced/revanced-cli" "revanced-cli" ".jar"); CLI_URL=${CLI_URL:1:-1}
INTEGRATIONS_URL=$(get_artifact_download_url "revanced/revanced-integrations" "app-release-unsigned" ".apk"); INTEGRATIONS_URL=${INTEGRATIONS_URL:1:-1}
PATCHES_URL=$(get_artifact_download_url "revanced/revanced-patches" "revanced-patches" ".jar"); PATCHES_URL=${PATCHES_URL:1:-1}

curl $CLI_URL -Lo revanced-cli.jar
curl $INTEGRATIONS_URL -Lo revanced-integrations.apk
curl $PATCHES_URL -Lo revanced-patches.jar

# Latest compatible version of apks
# YouTube Music 5.03.50
# YouTube 17.22.36
# Vanced microG 0.2.24.220220

YTM_VERSION="5.03.50"
YT_VERSION="17.22.36"
VMG_VERSION="0.2.24.220220"

APKEEP_URL=$(get_artifact_download_url "EFForg/apkeep" "apkeep-x86_64-unknown-linux-gnu"); APKEEP_URL=${APKEEP_URL:1:-1}
curl $APKEEP_URL -Lo apkeep
chmod +x apkeep
# ./apkeep -a com.google.android.youtube@17.22.36 com.google.android.youtube
# ./apkeep -a com.google.android.apps.youtube.music@5.03.50 com.google.android.apps.youtube.music
./apkeep -a com.mgoogle.android.gms@$VMG_VERSION .
mv com.mgoogle.android.gms@$VMG_VERSION.apk vanced-microG.apk

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
if [ -f "com.google.android.youtube.apk" ]
then
    echo "Building Root APK"
    java -jar revanced-cli.jar -m revanced-integrations.apk -b revanced-patches.jar \
                               -a com.google.android.youtube.apk -o build/revanced-root.apk
    echo "Building Non-root APK"
    java -jar revanced-cli.jar -m revanced-integrations.apk -b revanced-patches.jar \
                               -i codecs-unlock -i exclusive-audio-playback -i tasteBuilder-remover -i upgrade-button-remover -i background-play -i general-ads -i video-ads -i seekbar-tapping -i amoled -i disable-create-button -i minimized-playback -i old-quality-layout -i shorts-button -i microg-support \
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
    java -jar revanced-cli.jar -m revanced-integrations.apk -b revanced-patches.jar \
                               -a com.google.android.apps.youtube.music.apk -o build/revanced-music-root.apk
    echo "Building Non-root APK"
    java -jar revanced-cli.jar -m revanced-integrations.apk -b revanced-patches.jar \
                               -i codecs-unlock -i exclusive-audio-playback -i tasteBuilder-remover -i upgrade-button-remover -i background-play -i general-ads -i video-ads -i seekbar-tapping -i amoled -i disable-create-button -i minimized-playback -i old-quality-layout -i shorts-button -i microg-support \
                               -a com.google.android.apps.youtube.music.apk -o build/revanced-music-nonroot.apk
else
    echo "Cannot find YouTube Music APK, skipping build"
fi