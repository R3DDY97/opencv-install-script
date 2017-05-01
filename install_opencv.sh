#!/bin/bash

echo "Updating system packages "
echo
sudo apt update && sudo apt upgrade -y; sudo apt full-upgrade -y; sudo apt autoremove -y ;

echo "Installing required dependencies of open-cv \n"
echo
sudo apt-get install --assume-yes build-essential cmake git
sudo apt-get install --assume-yes build-essential pkg-config unzip ffmpeg qtbase5-dev python-dev python3-dev python3.5-dev
sudo apt-get install --assume-yes libopencv-dev libgtk-3-dev libdc1394-22 libdc1394-22-dev libjpeg-dev libpng12-dev libtiff5-dev libjasper-dev
sudo apt-get install --assume-yes libavcodec-dev libavformat-dev libswscale-dev libxine2-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev
sudo apt-get install --assume-yes libv4l-dev libtbb-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev
sudo apt-get install --assume-yes libvorbis-dev libxvidcore-dev v4l-utils
sudo apt-get install --assume-yes python-numpy python3-numpy python3-matplotlib
sudo -H pip3 uninstall opencv-python # since opencv-python presence doesnt allow compiled open-cv lib to run

cwd=$(pwd)

echo "Downloading open-cv source code from github"

wget -c https://github.com/opencv/opencv/archive/master.zip
file=$cwd/master.zip

if [ -f  "$file" ] ;
then
    unzip master.zip
    rm -rf master.zip
    mkdir opencv-master/build && cd opencv-master/build
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D BUILD_EXAMPLES=ON -D WITH_QT=ON -D WITH_GTK=ON -D WITH_OPENGL=ON ..
    make -j $(($(nproc) + 1))
    sudo make install
fi



echo "Checking whether open-cv installed properly or not "

sleep 1

pyfile=$cwd/check_installation.py
pic=$cwd/logo.png
if [ -f  "$pyfile" ] && [ -f  "$pic" ] ;
then
    $pyfile
else
    wget -c http://opencv.org/assets/theme/logo.png
    cat <<EOF > check_installation.py
#!/usr/bin/env python3

import numpy as np
import cv2

def check():
    try:
        print("\n\t Open-CV  installed Version == {} \n\n ".format(cv2.__version__))
        opencv = cv2.imread("logo.png")
        cv2.imshow("open-cv", opencv)
        cv2.waitKey(2500)  & 0xFF
        cv2.destroyAllWindows()
    except:
        print("\nopen-cv was not not properlycompiled and installed\n")

if __name__=="__main__":
    os.system("clear||cls")
    check()
EOF
python3 check_installation.py
rm check_installation.py logo.png
fi
