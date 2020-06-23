#!/bin/bash
echo "\e[1m\e[36mInstalling requirements\e[0m\e[39m"
sudo apt-get -qq update
sudo apt-get -qqy install python-pip python-dev python-setuptools python-virtualenv git libyaml-dev build-essential haproxy subversion libjpeg62-turbo-dev imagemagick ffmpeg libv4l-dev cmake avahi-daemon
echo "\e[1m\e[36mSetting up virtualenv\e[0m\e[39m"
virtualenv -q /home/pi/Aquarium
/home/pi/Aquarium/bin/pip -qq install pip --upgrade
/home/pi/Aquarium/bin/pip -qq install -Iv rsa==4.0
echo "\e[1m\e[36mInstalling Octoprint\e[0m\e[39m"
/home/pi/Aquarium/bin/pip -qq install octoprint 
echo "\e[1m\e[36mInstalling Bed Level Visualizer plugin\e[0m\e[39m"
/home/pi/Aquarium/bin/pip -qq install "https://github.com/jneilliii/OctoPrint-BedLevelVisualizer/archive/master.zip"
echo "\e[1m\e[36mInstalling Cost Estimation plugin\e[0m\e[39m"
/home/pi/Aquarium/bin/pip -qq install "https://github.com/malnvenshorn/OctoPrint-CostEstimation/archive/master.zip"
echo "\e[1m\e[36mInstalling Filament Manager plugin\e[0m\e[39m"
/home/pi/Aquarium/bin/pip -qq install "https://github.com/malnvenshorn/OctoPrint-FilamentManager/archive/master.zip"
echo "\e[1m\e[36mInstalling File Manager plugin\e[0m\e[39m"
/home/pi/Aquarium/bin/pip -qq install "https://github.com/Salandora/OctoPrint-FileManager/archive/master.zip"
echo "\e[1m\e[36mInstalling Layer Display plugin\e[0m\e[39m"
/home/pi/Aquarium/bin/pip -qq install "https://github.com/chatrat12/layerdisplay/archive/master.zip"
echo "\e[1m\e[36mInstalling Cancel Object plugin\e[0m\e[39m"
/home/pi/Aquarium/bin/pip -qq install "https://github.com/paukstelis/OctoPrint-Cancelobject/archive/master.zip"
echo "\e[1m\e[36mInstalling ETA plugin\e[0m\e[39m"
/home/pi/Aquarium/bin/pip -qq install "https://github.com/pablogventura/Octoprint-ETA/archive/master.zip"
echo "\e[1m\e[36mInstalling Print Time Genius plugin\e[0m\e[39m"
/home/pi/Aquarium/bin/pip -qq install "https://github.com/eyal0/OctoPrint-PrintTimeGenius/archive/master.zip"
echo "\e[1m\e[36mInstalling PrintTrack plugin\e[0m\e[39m"
/home/pi/Aquarium/bin/pip -qq install "https://github.com/ElectricSquid/OctoPrint-PrintTrack/archive/master.zip"
echo "\e[1m\e[36mInstalling OctoLapse plugin\e[0m\e[39m"
/home/pi/Aquarium/bin/pip -qq install "https://github.com/FormerLurker/Octolapse/archive/master.zip"
echo "\e[1m\e[36mInstalling Preheat Button plugin\e[0m\e[39m"
/home/pi/Aquarium/bin/pip -qq install "https://github.com/marian42/octoprint-preheat/archive/master.zip"
echo "\e[1m\e[36mInstalling OctoKlipper plugin\e[0m\e[39m"
/home/pi/Aquarium/bin/pip -qq install "https://github.com/mmone/OctoPrintKlipper/archive/master.zip"

echo "\e[1m\e[36mSetting up autostart\e[0m\e[39m"
[ ! -d /home/pi/.config/autostart ] && mkdir /home/pi/.config/autostart
sudo cp tightvnc.desktop /home/pi/.config/autostart
sudo cp octoprint.init /etc/init.d/octoprint
sudo cp octoprint.default /etc/default/octoprint
echo "\e[1m\e[36mSetting up webcam\e[0m\e[39m"
[ ! -d /home/pi/scripts ] && mkdir /home/pi/scripts
sudo cp webcam /home/pi/scripts
sudo cp webcamdaemon /home/pi/scripts
sudo chmod +x /etc/init.d/octoprint
sudo chmod +x /home/pi/scripts/webcam
sudo chmod +x /home/pi/scripts/webcamdaemon
sudo cp haproxy.cfg /etc/haproxy/haproxy.cfg
[ ! -d /home/pi/.octoprint ] && mkdir /home/pi/.octoprint
cat yamladdon >> /home/pi/.octoprint/config.yaml
echo "\e[1m\e[36mCloning mjpg streamer\e[0m\e[39m"
git clone -q https://github.com/jacksonliam/mjpg-streamer.git /home/pi/mjpg-streamer
echo "\e[1m\e[36mInstalling mjpg streamer\e[0m\e[39m"
cd /home/pi/mjpg-streamer/mjpg-streamer-experimental
export LD_LIBRARY_PATH=.
make --silent
sudo make --silent install
cd /home/pi
sudo rm -rf mjpg-streamer
echo "\e[1m\e[36mSetting up accesss via https://aquarium.local\e[0m\e[39m"
sudo hostnamectl set-hostname aquarium
[ ! -f /etc/hostname ] && sudo echo "aquarium" > /etc/hostname
sudo sed -i 's/raspberrypi/aquarium/g' /etc/hosts
echo "\e[1m\e[32mDone installing OctoPrint!\e[0m\e[39m"
