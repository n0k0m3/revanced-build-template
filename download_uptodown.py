import requests
import re
import subprocess

YT_URL = "https://youtube.en.uptodown.com/android/download/76287079"
YTM_URL = "https://youtube-music.en.uptodown.com/android/download/4668284"

def download_apk(url, filename):
    response = requests.get(url)
    dl_url = re.findall(r'(?<=href=")https:\/\/dw.uptodown.com.*?(?=")', response.content.decode("utf-8"))[0]
    subprocess.run(["wget", dl_url, "-O", filename])

print("Downloading YouTube...")
download_apk(YT_URL, "com.google.android.youtube.apk")
print("Downloading YouTube Music...")
download_apk(YTM_URL, "com.google.android.apps.youtube.music.apk")