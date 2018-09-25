#!bin/bash
CUR_DIR=`pwd`
cd $CUR_DIR
read -p "输入manager IP，该脚本执行一次即可 :" host
sed -i "s/10.10.10.7/$host/g" $CUR_DIR/remote.sh
echo "修改完成，请执行remote.sh进行安装"
