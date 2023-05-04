import urllib.request
import subprocess
import requests
import json
import yaml
import os
import re

from bs4 import BeautifulSoup

# Define class Packages
class Package:
    def __init__(self, package_name, version, uptodown, exclude_options):
        self.package_name = package_name
        self.version = version
        self.uptodown = uptodown
        self.exclude_options = exclude_options or []
        self.name_file = self.package_name + '-' + self.version.replace('.', '-') + '.apk'

# Load data from yaml file
def load_data_from_yaml_file(name_yaml_file):
    print('===== Load packages from', name_yaml_file, '=====')

    with open(name_yaml_file, 'r') as f:
        packages_data = yaml.safe_load(f)
    
    packages = []

    # Get `package_name`, `version`, `uptodown`, `exclude_options` for each package
    for package in packages_data.items():
        package_name = None
        version = None
        uptodown = None
        exclude_options = None

        # Get `package_name`
        package_name = package[0]

        # Get `version`
        version = package[1][0].get('version')

        # Get `uptodown`
        uptodown = package[1][1].get('uptodown')

        # If greater than 2, get more of `exclude_options`
        if len(package[1]) > 2:
            exclude_options = ' '.join(package[1][2].get('exclude_options'))
        
        packages.append(Package(package_name, version, uptodown, exclude_options))

        print('\t- Loaded:')
        print('\t\t- package_name:', package_name)
        print('\t\t- version:', version)
        print('\t\t- uptodown:', uptodown)
        print('\t\t- exclude_options:', exclude_options)
    
    return packages

# Download package
def download_package(package, folder_to_save):
    print('\t- Downloading', package.package_name, 'version', package.version)

    response = requests.get(package.uptodown)
    soup = BeautifulSoup(response.content, 'html.parser')

    version = soup.find('div', {'class': 'version'}).text

    if version == package.version:
        if not os.path.exists(folder_to_save + '/' + package.name_file):
            # Get URL of APK file
            url = soup.find('button', {'id': 'detail-download-button'})['data-url']

            print('\t\t- URL:', url)
            print('\t\t- Downloading', package.package_name, 'to\'', folder_to_save, '\' folder...')

            urllib.request.urlretrieve(url, os.path.join(folder_to_save, package.name_file))
        else:
            print('\t\t- Notification:', package.name_file, 'already exists')
    else:
        print('\t- Error:', package.version, 'not same with', version)
        return
    
    print('\t- Done', package.package_name, 'version', package.version)

# Download Revanced tools
def download_revanced_tools():
    # Create `revanced-tools` folder
    if not os.path.exists('revanced-tools'):
        os.makedirs('revanced-tools')
        print('===== Create \'revanced-tools\' folder =====')
    
    # Load data from json file
    with open('tools.json', 'r') as f:
        tools_data = json.load(f)
    
    print('===== Download to \'revanced-tools\' folder =====')

    for tool in tools_data:
        repo = tool['repo']
        name = tool['name']
        extension = tool['extension']

        print('\t- Downloading', name + extension)

        url_api = 'https://api.github.com/repos/{repo}/releases/latest'.replace('{repo}', repo)

        response = requests.get(url_api)
        api_data = json.loads(response.content)

        for asset in api_data['assets']:
            name_asset = asset['name']
            pattern = name + '.*\\' + extension
            
            if not os.path.exists('revanced-tools' + '/' + name + extension):
                if re.match(pattern, name_asset):
                    browser_download_url = asset['browser_download_url']

                    print('\t\t- URL:', browser_download_url)
                    print('\t\t- Downloading', name_asset, 'to \'revanced-tools\' folder...')

                    urllib.request.urlretrieve(browser_download_url, os.path.join('revanced-tools', name + extension))
            else:
                print('\t\t- Notification:', name + extension, 'already exists')
        
        print('\t- Done', name + extension)

# Main
if __name__ == "__main__":
    # Load data from yaml file
    packages = load_data_from_yaml_file('packages.yml')

    # Create `downloaded` folder
    if not os.path.exists('downloaded'):
        os.makedirs('downloaded')
        print('===== Create \'downloaded\' folder =====')
    
    # Download each package to `download` folder
    print('===== Download to \'downloaded\' folder =====')
    for package in packages:
        download_package(package, 'downloaded')
    
    # Download Revanced tools
    download_revanced_tools()

    # Create `build` folder
    if not os.path.exists('build'):
        os.makedirs('build')
        print('===== Create \'build\' folder =====')

    # Build APK files
    print('===== Build to \'build\' folder =====')

    for package in packages:
        command =   ['java',    '-jar', 'revanced-tools/revanced-cli.jar',
                                '-a', 'downloaded/' + package.name_file,
                                '-o', 'build/' + package.name_file,
                                '-b', 'revanced-tools/revanced-patches.jar',
                                '-m', 'revanced-tools/revanced-integrations.apk'
                    ]
        
        if package.exclude_options:
            command.append('-e')
            command.append(package.exclude_options)
        
        print('\t- Building', package.name_file, 'to \'build\' folder...')

        subprocess.run(command)

        print('\t- Done', package.name_file)