NOUT=/dev/null

echo Installing packages...
pip3 install alpaca-py > $NOUT

echo Package installation complete!

chmod +x ./bin/main.py
echo -e "\nRunning version $(cat version)\n"
nohup python3 ./bin/main.py &
