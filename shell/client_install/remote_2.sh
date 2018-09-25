#!/bin/bash  


CUR_DIR=`pwd`
cd $CUR_DIR 
rm -rf ssh.log
touch ssh.log 
#变量定义  
ip_array=("10.10.10.102/Passw0rd@2018" "10.10.10.216/Passw0rd1")  
#ip_array=($( awk '{print $1}' ip.txt))
remote_cmd="/root/sh.sh"  
  
#本地通过ssh执行远程服务器的脚本  
for str in ${ip_array[*]}  
do  
#    echo "str : [${str}]"
    ip=${str%%/*}
    pass_user=${str#*/}
#    user=${pass_user#*/}
#    pass=${pass_user%%/*}
    echo "ip : [${ip}]"
#    echo "user : [${user}]"
    echo "pass : [${pass_user}]"
#    sshpass -p $pass_user ssh  -o StrictHostKeychecking=no -p 9525   root@$ip  'ls'  
    #传输文件
sshpass -p $pass_user  scp  -P9525 client.tar.gz root@$ip:/opt/
#ssh -p 9525  root@10.10.10.102  << eeooff
#ssh root@10.10.10.159 > /dev/null 2>&1 << eeooff
sshpass -p $pass_user  ssh -p 9525 root@$ip  << eeooff 
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
echo "ip : [${ip}]"   >> ssh.log
sshpass -p $pass_user ssh  -o StrictHostKeychecking=no -p 9525   root@$ip  'ps -ef | grep client' >> ssh.log 

done  
