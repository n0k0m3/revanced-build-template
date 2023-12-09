#!/bin/bash

# Import build configuration
source build.targets

# File containing all patches
patch_file=./patches.txt

# Get line numbers where included & excluded patches start from. 
# We rely on the hardcoded messages to get the line numbers using grep
excluded_start="$(grep -n -m1 'EXCLUDE PATCHES' "$patch_file" | cut -d':' -f1)"
included_start="$(grep -n -m1 'INCLUDE PATCHES' "$patch_file" | cut -d':' -f1)"

# Get everything but hashes from between the EXCLUDE PATCH & INCLUDE PATCH line
# Note: '^[^#[:blank:]]' ignores starting hashes and/or blank characters i.e, whitespace & tab excluding newline
excluded_patches="$(tail -n +$excluded_start $patch_file | head -n "$(( included_start - excluded_start ))" | grep '^[^#[:blank:]]')"

# Get everything but hashes starting from INCLUDE PATCH line until EOF
included_patches="$(tail -n +$included_start $patch_file | grep '^[^#[:blank:]]')"

# Array for storing patches
declare -a patches

# Artifacts associative array aka dictionary
declare -A artifacts


if [ "$EXTENDED_SUPPORT" = "true" ]; then
artifacts["revanced-cli.jar"]="inotia00/revanced-cli revanced-cli .jar"
artifacts["revanced-integrations.jar"]="inotia00/revanced-integrations revanced-integrations .jar"
artifacts["revanced-patches.jar"]="inotia00/revanced-patches revanced-patches .jar"
else
artifacts["revanced-integrations.apk"]="revanced/revanced-integrations revanced-integrations .apk"
artifacts["revanced-cli.jar"]="revanced/revanced-cli revanced-cli .jar"
artifacts["revanced-patches.jar"]="revanced/revanced-patches revanced-patches .jar"
fi
artifacts["vanced-microG.apk"]="inotia00/VancedMicroG microg .apk"
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

# Function for populating patches array, using a function here reduces redundancy & satisfies DRY principals
populate_patches() {
    # Note: <<< defines a 'here-string'. Meaning, it allows reading from variables just like from a file
    while read -r patch; do
        patches+=("$1 $patch")
    done <<< "$2"
}

## Main

# cleanup to fetch new revanced on next run
if [[ "$1" == "clean" ]]; then
    rm -f revanced-cli.jar revanced-integrations.apk revanced-patches.jar vanced-microG.apk
    rm -rf build/*
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

# If the variables are NOT empty, call populate_patches with proper arguments
[[ ! -z "$excluded_patches" ]] && populate_patches "-e" "$excluded_patches"
[[ ! -z "$included_patches" ]] && populate_patches "-i" "$included_patches"

mkdir -p build

function build_youtube_root(){
echo "************************************"
echo "Building YouTube Root APK"
echo "************************************"

if [ -f "com.google.android.youtube.apk" ]; then
    java -jar revanced-cli.jar patch \
	-m revanced-integrations.apk \ 
	-b revanced-patches.jar \
	--mount \
        -e microg-support ${patches[@]} \
        $EXPERIMENTAL \
        -o "build/revanced-youtube-$(cat versions.json | grep -oP '(?<="com.google.android.youtube.apk": ")[^"]*')-root.apk" \
	com.google.android.youtube.apk
else
    echo "Cannot find YouTube APK, skipping build"
fi
}

function build_youtube_nonroot(){
echo "************************************"
echo "Building YouTube Non-root APK"
echo "************************************"

if [ -f "com.google.android.youtube.apk" ]; then
    java -jar revanced-cli.jar patch \
    	-m revanced-integrations.apk \
    	-b revanced-patches.jar \
        ${patches[@]} \
        $EXPERIMENTAL \
	-o "build/revanced-youtube-$(cat versions.json | grep -oP '(?<="com.google.android.youtube.apk": ")[^"]*').apk" \
 	com.google.android.youtube.apk
else
    echo "Cannot find YouTube APK, skipping build"
fi
}

function build_ytmusic_root(){
echo "************************************"
echo "Building YouTube Music APK"
echo "************************************"

if [ -f "com.google.android.apps.youtube.music.apk" ]; then
    echo "Building Root APK"
    java -jar revanced-cli.jar \
    	-b revanced-patches.jar \
     	--mount \
        -e microg-support ${patches[@]} \
        $EXPERIMENTAL \
        -o "build/revanced-music-$(cat versions.json | grep -oP '(?<="com.google.android.apps.youtube.music.apk": ")[^"]*')-root.apk" \
	com.google.android.apps.youtube.music.apk 
else
    echo "Cannot find YouTube Music APK, skipping build"
fi
}

function build_ytmusic_nonroot(){
echo "************************************"
echo "Building YouTube Music APK"
echo "************************************"

if [ -f "com.google.android.apps.youtube.music.apk" ]; then
    echo "Building Non-root APK"
    java -jar revanced-cli.jar patch \
    	-b revanced-patches.jar \
        ${patches[@]} \
        $EXPERIMENTAL \
        -o "build/revanced-music-$(cat versions.json | grep -oP '(?<="com.google.android.apps.youtube.music.apk": ")[^"]*').apk" \
	com.google.android.apps.youtube.music.apk
else
    echo "Cannot find YouTube Music APK, skipping build"
fi
}


function build_tiktok_nonroot(){
echo "************************************"
echo "Building TikTok APK"
echo "************************************"

if [ -f "com.zhiliaoapp.musically.apk" ]; then
    echo "Building Non-root APK"
    java -Xmx8192m -jar revanced-cli.jar patch \
    	-m revanced-integrations.apk \
     	-b revanced-patches.jar \
        ${patches[@]} \
        $EXPERIMENTAL \
        -o "build/revanced-tiktok-$(cat versions.json | grep -oP '(?<="com.zhiliaoapp.musically.apk": ")[^"]*').apk" \
	com.zhiliaoapp.musically.apk 
else
    echo "Cannot find TikTok APK, skipping build"
fi
}

function build_twitch_nonroot(){
echo "************************************"
echo "Building Twitch APK"
echo "************************************"

if [ -f "tv.twitch.android.app.apk" ]; then
    echo "Building Non-root APK"
    java -jar revanced-cli.jar patch \
    	-m revanced-integrations.apk \
     	-b revanced-patches.jar \
        ${patches[@]} \
        $EXPERIMENTAL \
        -o "build/revanced-twitch-$(cat versions.json | grep -oP '(?<="tv.twitch.android.app.apk": ")[^"]*').apk" \
	tv.twitch.android.app.apk 
else
    echo "Cannot find Twitch APK, skipping build"
fi
}

if [ "$YOUTUBE_ROOT" = "true" ]; then
	build_youtube_root
else
	printf "\nSkipping YouTube ReVanced (root)"
fi

if [ "$YOUTUBE_NONROOT" = "true" ]; then
	build_youtube_nonroot
else
	printf "\nSkipping YouTube ReVanced (nonroot)"
fi

if [ "$YTMUSIC_ROOT" = "true" ]; then
	build_ytmusic_root
else
	printf "\nSkipping YouTube Music ReVanced (root)"
fi

if [ "$YTMUSIC_NONROOT" = "true" ]; then
	build_ytmusic_nonroot
else
	printf "\nSkipping YouTube Music ReVanced (nonroot)"
fi

if [ "$TIKTOK_NONROOT" = "true" ] && [ "$EXTENDED_SUPPORT" != "true" ]; then
	build_tiktok_nonroot
else
	printf "\nSkipping TikTok (nonroot) due to disabled config or ReVanced Extended support being enabled in build.targets"
fi

if [ "$TWITCH_NONROOT" = "true" ] && [ "$EXTENDED_SUPPORT" != "true" ]; then
	build_twitch_nonroot
else
	printf "\nSkipping Twitch (nonroot) due to disabled config or ReVanced Extended support being enabled in build.targets"
fi

