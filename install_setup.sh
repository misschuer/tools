#!/bin/bash
echo 'start setup'

#创建一下log目录
if [ ! -d "/home/log" ];then
    mkdir /home/log
fi

#把必要的软件装一下
echo 'install git'
yum install git -y
echo 'install pymongo'
yum install pymongo -y

#安装mongodb
echo 'install mongodb'
yum install mongodb -y
yum install mongodb-server -y
#初始化一下mongodb环境
echo 'init mongodb'
if [ ! -d "/data" ];then
    mkdir /data
fi
if [ ! -d "/data/mongodb" ];then
    mkdir /data/mongodb
fi


#把运维工具下载下来
echo 'clone soft mgr'
cd /home
git clone https://misschuer@github.com/misschuer/soft_mgr.git

#把运维工具下载下来
echo 'clone openresty'
cd /opt
git clone https://misschuer@github.com/misschuer/openresty.git

#把配置服下载下来
echo 'clone conf_svr'
cd /home
git clone https://misschuer@github.com/misschuer/conf_svr.git

#把跨服下载下来
echo 'clone ext_web'
cd /home
git clone https://misschuer@github.com/misschuer/ext_web.git

#开始安装服务器运行必须的一大堆东西了（网关啊，booost啊）
echo 'install server mgr'
cd /home
git clone https://misschuer@github.com/misschuer/server-mgr.git
#下载网关服和安全认证
cd /home/server-mgr/bin
chmod +x *
#下载booost运行环境
cd /home/server-mgr/lib
chmod +x libboost_filesystem.so.1.55.0
chmod +x libboost_regex.so.1.55.0
chmod +x libboost_system.so.1.55.0
#为操作系统建立booost链接
cd /etc/ld.so.conf.d
cat << EOF > cow.conf
/home/server-mgr/lib/ 
EOF
ldconfig
#下载c++动态库
cd /home/server-mgr/lib
#为c++动态库建立链接
rm /usr/lib64/libstdc++.so.6
cp /home/server-mgr/lib/libstdc++.so.6.0.17 /usr/lib64/libstdc++.so.6.0.17
ln -s /usr/lib64/libstdc++.so.6.0.17 /usr/lib64/libstdc++.so.6
