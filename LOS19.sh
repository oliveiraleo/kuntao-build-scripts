#!/usr/bin/env bash

# Check shell type first
case "$-" in
    *i*)
        echo "LOS19.1 build script started!"
        ;;
    *)
        echo "[ERROR] This shell is not interactive!"
        echo "[INFO] TIP: Try to run this script using the command below"
        echo "bash -i $0"
        exit 1
        ;;
esac

# Install prerequisites
sudo apt install -y bc bison build-essential ccache curl flex g++-multilib gcc-multilib git git-lfs gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev libelf-dev liblz4-tool libncurses5 libncurses5-dev libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev libwxgtk3.0-gtk3-dev openjdk-11-jdk android-platform-tools-base python-is-python3

# Create the directories for the sources
mkdir -p ~/bin && mkdir -p ~/android/lineage

# Install repo
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
source ~/.profile

# Configure git
git config --global color.ui true && git config --global user.email "oliveiraleo@users.noreply.github.com" && git config --global user.name "oliveiraleo"

# Configure cache
# export USE_CCACHE=1 && export CCACHE_EXEC=/usr/bin/ccache && ccache -M 20G
# disabled for now
# NOTE: Recommended by docs is 50GB (for kuntao LOS 20GB should be enough)

# Initialize the LOS source repository
cd ~/android/lineage
repo init -u https://github.com/LineageOS/android.git -b lineage-19.1 --git-lfs

# Download the source code
repo sync -j 6 # todo get CPU cores from nproc

# Clone the DT
mkdir -p device/lenovo/kuntao
git clone -b lineage-19.1 https://github.com/Astridxx/android_device_lenovo_kuntao device/lenovo/kuntao

# Prepare device-specific code (clones kernel, vendor, device patches, etc trees)
source build/envsetup.sh
# breakfast kuntao

# Delete the vendorsetup.sh file
rm device/lenovo/kuntao/vendorsetup.sh

# Build
croot
brunch kuntao
