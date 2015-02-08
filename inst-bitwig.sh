# simple script to install bitwig studio package on Fedora (tested with 21)
# There appear to be a couple of issues with Bitwig on Fedora
# 1 The factory sound content dosent seem to want to download
# 2 Some file formats will not play out of the box

bitwig_package=$1

# Check user is root
if [ $(id -u) != 0 ]; then
  echo "You must run this script as root!"
  exit 1
fi

#check that package is specified
if [ -z "$bitwig_package" ]
  then
    echo "You must specify a version of bitwig"
    exit 1
fi

# Create a working dir
mkdir ~/bitwig-install
cd ~/bitwig-install

#check if package has been downloaded
if [ -f /home/*/Downloads/bitwig-studio-$bitwig_package.deb ]; then
    echo "Package is downloaded"
    p=`ls -A /home/*/Downloads/bitwig-studio-$bitwig_package.deb`
    mv $p ~/bitwig-install
else
    echo "You must download the bitwig $bitwig_package package first"
    exit 1
fi

# UPDATE: install dependencies
yum -y install xcb-util dpkg

# Unpack it
dpkg -x bitwig-studio-$bitwig_package.deb .

# Copy everything to its rightful place
rsync -auv ./opt ./usr /

# Clean up the mess
cd
rm -fr ~/bitwig-install
