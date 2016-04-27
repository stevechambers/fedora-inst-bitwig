#!/bin/bash
# simple script to install bitwig studio package on Fedora (tested with 23)

bitwig_package=$1

# Check user is root
if [ "$(id -u)" != 0 ]; then
  echo "You must run this script as root!"
  exit 1
fi

# Check that package is specified
if [ -z "${bitwig_package}" ]; then
    echo "You must specify a version of bitwig"
    exit 1
fi

# Check that bitwig version is tested
if [ "$bitwig_package" == '1.3.9' ]; then
  echo "Bitwig $bitwig_package is supported"
else
  echo -e "This script has not been tested with $bitwig_package\nRunning on an untested version of Bitwig may have unintended consequences"
  read -r -p "Are you sure you wish to proceed? [y/N] " response
  case $response in
      [yY][eE][sS]|[yY])
          echo "OK but don't say I didn't warn you!"
          ;;
      *)
          exit 0
          ;;
  esac
fi

# Check OS
if [ "$(cat /etc/fedora-release)" == 'Fedora release 23 (Twenty Three)' ]; then
  echo 'OS is supported'
else
  echo -e 'This script has only been tested on Fedora 23\nRunning on an untested OS may have unintended consequences'
  read -r -p "Are you sure you wish to proceed? [y/N] " response
  case $response in
      [yY][eE][sS]|[yY])
          echo "OK but don't say I didn't warn you!"
          ;;
      *)
          exit 0
          ;;
  esac
fi

#check if package has been downloaded
if [ -f /home/*/Downloads/bitwig-studio-$bitwig_package.deb ]; then
    echo "Package is downloaded"
    p=$(ls -A /home/*/Downloads/bitwig-studio-$bitwig_package.deb)
    # Create a working dir
    mkdir ~/bitwig-install
    cp $p ~/bitwig-install
    cd ~/bitwig-install
else
    echo "You must download the bitwig ${bitwig_package} package first"
    exit 1
fi

# UPDATE: install dependencies
echo 'installing dependancies'
dnf -y install xcb-util dpkg

# Unpack it
echo 'Unpacking bitwig'
dpkg -x "bitwig-studio-$bitwig_package.deb" .

# Copy everything to its rightful place
echo 'installing'
rsync -auv ./opt ./usr /

# Clean up the mess
echo 'Cleaning up'
cd
rm -fr ~/bitwig-install

# Add support for compressd audio formats
# See http://lunardigs.com/articles/2014/10/08/installation-of-bitwig-studio-1.0-on-fedora-20,-with-flac-and-mp3-support/
ln -s ffprobe avprobe
ln -s ffplay avplay
ln -s ffmpeg avconv
ln -s ffserver avserver

# Fix https://github.com/stevechambers/fedora-inst-bitwig/issues/4
ln -s /usr/lib64/libbz2.so.1 /usr/lib64/libbz2.so.1.0
