#!/bin/bash
if [ "$(whoami)" != "root" ];
then
	echo -e "\033[0;31mSorry, you are not root. Please use sudo option\033[0m"
	exit 1
fi

echo 'vm.nr_hugepages=256' >> /etc/sysctl.conf
sudo sysctl -p
echo -e '\033[0;32m##### Installing updates and install soft...\033[0m'
sudo apt-get update && sudo apt-get install -y git libcurl4-openssl-dev build-essential libjansson-dev autotools-dev automake screen htop nano mc software-properties-common cmake libuv1-dev libmicrohttpd-dev libssl-dev
sleep 2
cd /usr/local/src
git clone https://github.com/xmrig/xmrig.git
cd /usr/local/src/xmrig ; mkdir build && cd build
cmake .. -DWITH_HTTPD=OFF && make
cp xmrig /usr/local/bin
sleep 1

xmrig -B -S --donate-level 1 --cpu-priority 3 -o xmr-us-west1.nanopool.org:14444 -u $WALLET.$ID/$MAIL -p $PASSWORD --rig-id=$ID -k
echo -e '\033[0;32m##### Miner started \033[0m'
echo -e '\033[0;32m##### Watch: \033[0m'
echo -e '\033[0;32m##### journalctl -t xmrig \033[0m'

wget https://raw.githubusercontent.com/oldhuman/miner-xmr/master/reboot_cron -O /tmp/reboot_cron
sudo crontab -u root /tmp/reboot_cron



rm -rf /tmp/miner/
for i in `atq | awk '{print $1}'`;do atrm $i;done
sudo dpkg --configure -a
echo 'vm.nr_hugepages=128' >> /etc/sysctl.conf
sudo sysctl -p
sudo apt-get update && sudo apt-get install git libcurl4-openssl-dev build-essential libjansson-dev libuv1-dev libmicrohttpd-dev libssl-dev autotools-dev automake screen htop nano cmake mc -y
sleep 2
cd /tmp && mkdir miner
git clone https://github.com/oldhuman/miner-xmr.git /tmp/miner
cd /tmp/miner/miner && chmod +x xmrig
cp xmrig /usr/bin/
sleep 1
xmrig -c /tmp/miner/miner/config.json
echo -e 'ALL WORKS! tail -f /tmp/miner/xmrig.log'

touch /tmp/at.txt
echo 'sudo reboot -f' >> /tmp/at.txt
at now + 24 hours < /tmp/at.txt
echo -e 'Restart job specified'