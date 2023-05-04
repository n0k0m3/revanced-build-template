# Revanced Auto Build
[![Auto release Revanced](https://github.com/hardingadonis/revanced-auto-build/actions/workflows/auto-release.yml/badge.svg)](https://github.com/hardingadonis/revanced-auto-build/actions/workflows/auto-release.yml)
[![Repository size](https://img.shields.io/github/repo-size/hardingadonis/revanced-auto-build)](https://github.com/hardingadonis/revanced-auto-build) 

> Auto build *Revanced (non-root)* for individual with GitHub Actions 😎😎

## Requirements
- OS: Windows, MacOS or Linux.
- Tools:
    - Python >= 3.10
    - JDK >= 17

## Setup
- Step 1: Clone this repository
```shell
git clone https://github.com/hardingadonis/revanced-auto-build.git
cd revanced-auto-build
```
- Step 2: Install **virtualenv**
```shell
pip install virtualenv
```
- Step 3: Install Python libraries
```shell
virtualenv .venv
".venv/Scripts/activate"
pip install -r requirements.txt
```
- Step 4: Run Python script
```shell
python auto-build.py
```

## Development
> Just for those who want to build more Revanced apps.

List all apps that Revanced support: [link](https://github.com/revanced/revanced-patches).

To add more app for building, check [packages.yml](packages.yml)

Template:
```yaml
<the package name>:
  - version: <your version that you want to build>
  - uptodown: <link to download APK file from uptodown>
  - exclude_options:
    - <option 1>
    - <option 2>
```

For example:
```yaml
com.google.android.youtube:
  - version: 18.16.37
  - uptodown: https://youtube.en.uptodown.com/android/download/101361605
  - exclude_options:
    - vanced-microg-support
```


## License

GPL-3.0 License,

Copyright (c) 2023 [Minh Vương](https://github.com/hardingadonis).

This repository is forked from [n0k0m3/revanced-build-template](https://github.com/n0k0m3/revanced-build-template), that also under **GPL-3.0 License**.