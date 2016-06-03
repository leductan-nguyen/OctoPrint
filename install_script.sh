################ 3DRAION INSTALLATION SCRIPT #####################

################ REQUIREMENTS ##############
#Raspbian or Raspbian Lite
#Internet connection on eth0
#Worked on Raspbian Jessie 10-5-2016

#get ip adress on eth0
echo An Internet connection on eth0 is required. Checking connection ...
IP=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' 2>&1)
echo Your adress IP is $IP

############### OCTOPRINT ##############
#instal dependencies, virtual environement then Octoprint
echo Install dependencies, virtual environement then Octoprint ...
cd ~
sudo apt-get install python-pip python-dev python-setuptools python-virtualenv git libyaml-dev build-essential
git clone https://github.com/foosel/OctoPrint.git
cd OctoPrint
virtualenv venv
./venv/bin/pip install pip --upgrade
./venv/bin/python setup.py install
mkdir ~/.octoprint
#add the pi user to the dialout group and tty so that the user can access the serial ports
sudo usermod -a -G tty pi
sudo usermod -a -G dialout pi

#updating (optional)
#cd ~/OctoPrint/
#git pull
#./venv/bin/python setup.py install

echo Done.

############### WEBCAM ################
#compilation
echo Install webcam streaming ...
cd ~
sudo apt-get install subversion libjpeg8-dev imagemagick libav-tools cmake
git clone https://github.com/jacksonliam/mjpg-streamer.git
cd mjpg-streamer/mjpg-streamer-experimental
export LD_LIBRARY_PATH=.
make

#test (optional)
#./mjpg_streamer -i "./input_uvc.so" -o "./output_http.so"
#for some device may have to add option -y
#./mjpg_streamer -i "./input_uvc.so -y" -o "./output_http.so" 
#if use raspi cam module
#./mjpg_streamer -i "./input_raspicam.so -fps 5" -o "./output_http.so" 

touch ~/.octoprint/config.yaml
echo "webcam:" >> ~/.octoprint/config.yaml
echo "  stream: http://"$IP":8080/?action=stream" >> ~/.octoprint/config.yaml
echo "  snapshot: http://127.0.0.1:8080/?action=snapshot" >> ~/.octoprint/config.yaml
echo "  ffmpeg: /usr/bin/avconv" >> ~/.octoprint/config.yaml

cd ~
mkdir -p /home/pi/scripts
cat <<EOT >> /home/pi/scripts/webcam
#!/bin/bash
# Start / stop streamer daemon

case "$1" in
    start)
        /home/pi/scripts/webcamDaemon >/dev/null 2>&1 &
        echo "$0: started"
        ;;
    stop)
        pkill -x webcamDaemon
        pkill -x mjpg_streamer
        echo "$0: stopped"
        ;;
    *)
        echo "Usage: $0 {start|stop}" >&2
        ;;
esac
EOT

cat <<EOT >> /home/pi/scripts/webcamDaemon
