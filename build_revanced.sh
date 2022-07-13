#!/bin/bash

# File containing all patches
patches=./patches.txt

# Artifacts associative array aka dictionary
declare -A artifacts

# Array for storing excluded patches
declare -a excluded_patches

artifacts["revanced-cli.jar"]="revanced/revanced-cli revanced-cli .jar"
artifacts["revanced-integrations.apk"]="revanced/revanced-integrations app-release-unsigned .apk"
artifacts["revanced-patches.jar"]="revanced/revanced-patches revanced-patches .jar"
artifacts["apkeep"]="EFForg/apkeep apkeep-x86_64-unknown-linux-gnu"

## Functions

get_artifact_download_url() {
    # Usage: get_download_url <repo_name> <artifact_name> <file_type>
    local api_url result
    api_url="https://api.github.com/repos/$1/releases/latest"
    # shellcheck disable=SC2086
    result=$(curl -s $api_url | jq ".assets[] | select(.name | contains(\"$2\") and contains(\"$3\") and (contains(\".sig\") | not)) | .browser_download_url")
    echo "${result:1:-1}"
}

## Main

# cleanup to fetch new revanced on next run
if [[ "$1" == "clean" ]]; then
    rm -f revanced-cli.jar revanced-integrations.apk revanced-patches.jar
    exit
fi

if [[ "$1" == "experimental" ]]; then
    EXPERIMENTAL="--experimental"
fi

# Fetch all the dependencies
for artifact in "${!artifacts[@]}"; do
    if [ ! -f "$artifact" ]; then
        echo "Downloading $artifact"
        # shellcheck disable=SC2086,SC2046
        curl -sLo "$artifact" $(get_artifact_download_url ${artifacts[$artifact]})
    fi
done

# Fetch microG
chmod +x apkeep

if [ ! -f "vanced-microG.apk" ]; then

    # Vanced microG 0.2.24.220220
    VMG_VERSION="0.2.24.220220"

    echo "Downloading Vanced microG"
    ./apkeep -a com.mgoogle.android.gms@$VMG_VERSION .
    mv com.mgoogle.android.gms@$VMG_VERSION.apk vanced-microG.apk
fi

echo "************************************"
echo "Building YouTube APK"
echo "************************************"

mkdir -p build

# All patches will be included by default, you can exclude patches by writing their name in patches.txt

# Check if there is anything in patches which does NOT start with a hash
if grep -q '^[^#]' $patches; then
    # If yes, output from grep command below is fed into read which assign it to patch & ultimately store it in our array of excluded_patches
    # Note: 'read' reads until it hits a newline, grep preserves newline. Thus, we get all patches in one huge chunk & read reads them one by one until EOF
    while read -r patch; do
        excluded_patches+=("-e $patch")
    done < <(grep '^[^#]' $patches)
fi

if [ -f "com.google.android.youtube.apk" ]; then
    echo "Building Root APK"
    java -jar revanced-cli.jar -m revanced-integrations.apk -b revanced-patches.jar --mount \
        -e microg-support ${excluded_patches[@]} \
        $EXPERIMENTAL \
        -a com.google.android.youtube.apk -o build/revanced-root.apk
    echo "Building Non-root APK"
    java -jar revanced-cli.jar -m revanced-integrations.apk -b revanced-patches.jar \
        ${excluded_patches[@]} \
        $EXPERIMENTAL \
        -a com.google.android.youtube.apk -o build/revanced-nonroot.apk
else
    echo "Cannot find YouTube APK, skipping build"
fi
echo ""
echo "************************************"
echo "Building YouTube Music APK"
echo "************************************"
if [ -f "com.google.android.apps.youtube.music.apk" ]; then
    echo "Building Root APK"
    java -jar revanced-cli.jar -b revanced-patches.jar --mount \
        -e microg-support ${excluded_patches[@]} \
        $EXPERIMENTAL \
        -a com.google.android.apps.youtube.music.apk -o build/revanced-music-root.apk
    echo "Building Non-root APK"
    java -jar revanced-cli.jar -b revanced-patches.jar \
        ${excluded_patches[@]} \
        $EXPERIMENTAL \
        -a com.google.android.apps.youtube.music.apk -o build/revanced-music-nonroot.apk
else
    echo "Cannot find YouTube Music APK, skipping build"
fi
