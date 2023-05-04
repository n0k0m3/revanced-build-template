import urllib.request
import requests
import yaml
import os

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

        print('- Loaded:')
        print('\t- package_name:', package_name)
        print('\t- version:', version)
        print('\t- uptodown:', uptodown)
        print('\t- exclude_options:', exclude_options)
    
    return packages

# Download package
def download_package(package, folder_to_save):
    print('- Downloading', package.package_name, 'version', package.version)

    response = requests.get(package.uptodown)
    soup = BeautifulSoup(response.content, 'html.parser')

    version = soup.find('div', {'class': 'version'}).text

    if version == package.version:
        if not os.path.exists(folder_to_save + '/' + package.name_file):
            # Get URL of APK file
            url = soup.find('button', {'id': 'detail-download-button'})['data-url']

            print('\t- URL:', url)
            print('\t- Downloading', package.package_name, 'to\'', folder_to_save, '\' folder...')

            urllib.request.urlretrieve(url, os.path.join(folder_to_save, package.name_file))
        else:
            print('\t- Notification:', package.name_file, 'already exists')
    else:
        print('- Error:', package.version, 'not same with', version)
        return
    
    print('- Done', package.package_name, 'version', package.version)

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