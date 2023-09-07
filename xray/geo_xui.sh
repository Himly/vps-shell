#!/bin/bash

cd /usr/local/x-ui/bin
rm -f geoip.dat geosite.dat
wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat
wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat
chmod 755 geoip.dat geosite.dat
