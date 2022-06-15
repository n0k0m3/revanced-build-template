#!/bin/bash
PATH=$PATH:$ANDROID_HOME/build-tools/32.0.0/
openssl base64 -d -A <<< $(echo $SIGNING_KEY_BASE64) > build/generic.keystore

for f in build/*.apk; do
    mv $f ${f%.apk}.apk.unsigned
    echo "Zipaligning $f"
    zipalign -pvf 4 ${f%.apk}.apk.unsigned $f
    rm ${f%.apk}.apk.unsigned
    echo "Signing $f"
    echo $(apksigner --version)
    apksigner sign --ks build/generic.keystore --ks-pass pass:$KEY_STORE_PASSWORD $f
done
