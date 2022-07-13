import requests
import re
import subprocess
import json

URL_DICT = {
    "youtube": [
        # "https://youtube.en.uptodown.com/",
        "https://youtube.en.uptodown.com/android/apps/16906/versions"
        ],
    "ytmusic": [
        # "https://youtube-music.en.uptodown.com/",
        "https://youtube-music.en.uptodown.com/android/apps/146929/versions"
        ]
}

with open("versions.json", "r") as f:
    VERSIONS = json.load(f)

def get_version_link(product="youtube"):
    # # Get version URL from scraping uptodown
    # url = URL_DICT[product][0]
    # response = requests.get(url+"android/versions")
    # regex_str = r'(?<=data-url=")' + url.replace(".", r"\.").replace("/", r"\/") + r'android\/download\/\d+(?=">\n{})'.format(VERSIONS[product].replace(".", r"\."))
    # result = re.findall(regex_str, response.content.decode("utf-8"))

    # Search in UTD API
    url = URL_DICT[product][0]
    response = requests.get(url).json()
    for version in response["data"]:
        if version["version"] == VERSIONS[product]:
            return version["versionURL"]

def download_apk(product, filename):
    version_url = get_version_link(product)

    response = requests.get(version_url)
    dl_url = re.findall(r'(?<=href=")https:\/\/dw.uptodown.com.*?(?=")', response.content.decode("utf-8"))[0]

    subprocess.run(["wget", dl_url, "-O", filename])

print("Downloading YouTube...")
download_apk("youtube" , "com.google.android.youtube.apk")
print("Downloading YouTube Music...")
download_apk("ytmusic", "com.google.android.apps.youtube.music.apk")