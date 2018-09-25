#!/bin/sh
CUR_DIR=`pwd`
client="client-1.01-1.el7.centos.x86_64"

#获取版本字符串，使用cat /etc/redhat-release  | awk '{print $3 }'  获取时候不同版本值的位置不同
version=`cat /etc/redhat-release  |  tr -cd "[0-9]" `
#获取版本号第一位
int=${version:0:1}
echo "判断系统版本"
if [[ "$int" != "6" &&  "$int" != "7" ]];then
    echo "暂不支持该操作系统安装"
    exit 5
fi
echo "支持该操作系统安装，开始配置环境......."
echo "-----------------------------------------------"
echo "###关闭selinux 修改时间为CST 关闭防火墙"
setenforce 0
sed -i 's/enforcing/disabled/g' /etc/selinux/config

mv /etc/localtime /etc/localtime.bak
ln -s /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
clock -w
date

if [ "$int" -eq  "6" ]  ;then
        systemctl stop firewalld
        systemctl disable firewalld
elif [ "$int" -eq  "7" ];then
        systemctl stop firewalld
        systemctl disable firewalld
fi
echo "###selinux及防火墙关闭完成"


echo "install client"

rpm -e $client

cd $CUR_DIR
rpm -ivh $client.rpm --nodeps

#read -p "Please enter the  interface :" interface

interface=`ifconfig|grep "^e"| awk '{print $1}' | sed  "s/:\+//g"`

sed -i "s/eth0/$interface/g" /opt/meiying/client/conf/env.ini

read -p "Please enter the manager IP :" host

sed -i "s/172.16.0.36/$host/g" /opt/meiying/client/conf/env.ini

cd /etc/rsyslog.d
mv iptables.conf iptables.conf_bak
touch iptables.conf
echo ":msg,contains,\"iptables_honeypot\"  @@$host:514" >> //etc/rsyslog.d/iptables.conf
systemctl restart rsyslog 
mkdir /tmp/client
echo "\$imjournalRatelimitInterval 1"  >>/etc/rsyslog.conf 
echo "\$imjournalRatelimitBurst 50000"  >>/etc/rsyslog.conf 
systemctl restart systemd-journald.service
systemctl restart rsyslog.service

sed  -i '/9525/d' /etc/ssh/sshd_config
echo "Port = 9525" >> /etc/ssh/sshd_config 
systemctl restart sshd


echo " Installation Complete"

