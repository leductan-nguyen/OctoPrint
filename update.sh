git pull
./venv/bin/python setup.py install
echo Update finished.
echo Now restart server...
octoprint --daemon restart
echo Done. Server restarted.
