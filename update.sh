cd /home/pi/RaionPi/
git pull
./venv/bin/python setup.py install
echo Update finished.
echo Now restart server...
raionpi --daemon restart
echo Done. Server restarted.
