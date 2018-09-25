#!/bin/bash
#按照网络接口，tcp目的端口及按照5s来抓取
nohup tshark  -i ens32   -b duration:5  tcp port 502   -T pdml -w  mudbus.pcap  &
nohup tshark  -i ens32   -b duration:5  tcp port 102   -T pdml -w  snap7.pcap  &
#通过循环对抓取的文件进行操作
int=2
while(( $int<=1280000 ))
do
#查找5s前未改动过的“.pcap”结尾的文件
	filelist=`find . -cmin +0.084  -type f -name "*.pcap" `
	for file in $filelist
	do 
#去掉后缀名，取文件名	
	 name=${file%.*}
#查看文件大小
         filesize=`du  -b ./$file  | awk '{print $1}' `
	 size1=212
#         if [ $filesize -eq $size1  ];then
#判断文件是否为空，将非空的文件进行xml格式转换按照原名保存，将pcap文件备份，将转换后的文件输入到指定文件夹
         if [ $filesize -gt  $size1  ];then
         tshark -r $file -O s7comm,bacnet,opcua,modbus,enip,cip,dnp3,mms,goose,sv -Tfields  -E header=y -T pdml > $name.xml
         mv $file /tmp/bak/
         mv $name.xml /tmp/xml/
         fi
	 rm -rf $file
	done
done	  
#find . -cmin +1  -type f -name "*.pcap"  -exec tshark -r {} -O s7comm,bacnet,opcua,modbus,enip,cip,dnp3,mms,goose,sv -Tfields  -E header=y -T pdml > modbu_%Y%m%d%H%M%S.xml  \;
