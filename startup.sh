NOUT=/dev/null

if ! command -v python &> $NOUT; then
  echo Python is not installed. Exiting.
  exit
elif ! command -v python &> $NOUT; then
  echo Pip failed. Exiting.
  exit
fi

echo Checking packages are installed.

installed_packages=$(pip list --format=columns | awk 'NR>2 {print $1 "==" $2}')
while read -r package; do
  if ! echo "$installed_packages" | grep -q "$package"; then
    pip install --force-reinstall "$package" > $NOUT
  fi
done < dependencies

echo Package validation complete.

echo Checking for InfluxDB installation.

mkdir downloads
curl -LSs https://dl.influxdata.com/influxdb/releases/influxdb2-2.7.1-windows-amd64.zip -o ./downloads/influxdb2-2.7.1-windows-amd64.zip
unzip ./downloads/influxdb2-2.7.1-windows-amd64.zip -d ./downloads/
mv ./downloads/influxdb2-2.7.1-windows-amd64/influxd.exe .

if ! [ -d dataset ]; then
  echo Downloading dataset.
  mkdir dataset
  chmod +x ./bin/first_time.py
  python ./bin/first_time.py
fi

chmod +x ./bin/main.py
echo -e "\nRunning version $(cat version)\n"
nohup python ./bin/main.py &
