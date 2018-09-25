#!/bin/bash

read -p "输入探针ip:" client
CUR_DIR=`pwd`
#client="10.10.10.102"
port="9525"
user="root"

#传输文件
sshpass -p Passw0rd@2018  scp  -P$port client.tar.gz $user@$client:/opt/install_package/
Passw0rd@2018
#ssh -p 9525  root@10.10.10.102  << eeooff
#ssh root@10.10.10.159 > /dev/null 2>&1 << eeooff
sshpass -p Passw0rd@2018  ssh -p $port $user@$client  << eeooff 
Passw0rd@2018
#开始安装
cd /opt/
tar -zxvf client.tar.gz
cd /opt/client/
sh client_install.sh
10.10.10.210
cd /opt/supervisor_client/
sh supervisor.sh
exit
eeooff
echo done!
