echo 'install yum-utils'
yum install -y yum-utils

yum-config-manager --add-repo https://openresty.org/package/centos/openresty.repo
# 更新源
cat << EOF > /etc/yum.repos.d/mongodb-org-3.4.repo
[mongodb-org-3.4]  
name=MongoDB Repository  
baseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/3.4/x86_64/  
gpgcheck=0  
enabled=1  
gpgkey=https://www.mongodb.org/static/pgp/server-3.4.asc
EOF

yum update -y

echo 'install git'
yum install -y git

# 安装openresty-resty 1.13.6
echo 'install openresty-resty 1.13.6'
yum install -y openresty-resty

# 安装mongodb3.4
echo 'install mongodb-org'
yum install -y mongodb-org
if [ ! -d "/data" ];then
    mkdir /data
fi
if [ ! -d "/data/mongodb" ];then
    mkdir /data/mongodb
fi

# 再另外一个终端输入 mongod --dbpath=/data/mongodb --port 27017
# 加admin超级用户
# mongo admin --eval "db.createUser({user:\"admin\", pwd:\"qwe123QWE\", roles:[{role:\"userAdminAnyDatabase\", db:\"admin\"}]})"
# 如果是一个root管理所有库
# # mongo admin --eval "db.createUser({user:\"admin\", pwd:\"qwe123QWE\", roles:[{role:\"root\", db:\"admin\"}]})"

# 加单个数据库的用户
# mongo app --eval "db.createUser({user:\"miss\", pwd:\"chuer\", roles:[\"readWrite\", \"dbAdmin\"]})"

# mongodb 加入 start_all.sh 和 stop_all.sh
# start_all.sh
#启动mongodb
#if [[ -z `ps -ef|grep mongod|grep -v grep|awk {'print $2'}` ]]; then
#    echo 'start mongodb'
#    nohup mongod --dbpath=/data/mongodb --port 27017 --auth > /data/mongodb/log.out 2>&1 &
#    sleep 2
#fi

# stop_all.sh
# kill mongodb
#mid=`ps -ef|grep mongod|grep -v grep|awk {'print $2'}`
#if !([ -z "$mid" ];) then
#    echo "killed mongod", $mid
#    kill $mid
#fi

#安装redis4
yum install -y gcc gcc-c++

#安装wget
yum install -y wget
redis=redis-4.0.6
wget http://download.redis.io/releases/$redis.tar.gz
tar xzvf $redis.tar.gz
cd $redis
make MALLOC=libc
cd src && make install

cd ..
# 配置redis启动环境
if [ ! -d "/etc/redis" ];then
    mkdir /etc/redis
fi
# 把redis.conf里面的daemonize 改成yes
cp `pwd`/redis.conf /etc/redis/6379.conf
cp `pwd`/utils/redis_init_script /etc/init.d/redisd
#cd /etc/init.d
#在redisd的前面加2行(#!/bin/sh后面)
# chkconfig:   2345 90 10
# description:  Redis is a persistent key-value database
#chkconfig redisd on
# 启动
# service redisd start

# 配置adminmongo
if [ ! -d "/home/setup" ];then
    mkdir /home/setup
fi

# 安装nodejs
#nodejs=node-v6.9.1
#wget https://npm.taobao.org/mirrors/node/v6.9.1/$node.tar.gz
#tar xzvf $nodejs.tar.gz
#cd $nodejs
#./configure
#make && make install

nodejs=node-v8.11.1-linux-x64
wget https://nodejs.org/dist/v8.11.1/$nodejs.tar.xz
tar --strip-components 1 -xvf $nodejs.tar.xz -C /usr/local

npm config set registry https://registry.npm.taobao.org
cat << EOF > ~/.npmrc
registry=https://registry.npm.taobao.org
sass_binary_site=https://npm.taobao.org/mirrors/node-sass/
phantomjs_cdnurl=http://npm.taobao.org/mirrors/phantomjs
ELECTRON_MIRROR=http://npm.taobao.org/mirrors/electron/
EOF

# 启动adminmongo
cd /home/setup
git clone https://github.com/mrvautin/adminMongo
cd adminMongo
npm install

# 添加防火墙1234端口
firewall-cmd --zone=public --add-port=1234/tcp --permanent
firewall-cmd --zone=public --add-port=8085/tcp --permanent
firewall-cmd --reload

# 安装jdk
# 下载之前先得确定地址能用
jdk=jdk-8u172-linux-x64
wget http://download.oracle.com/otn-pub/java/jdk/8u172-b11/a58eab1ec242421181065cdc37240b08/$jdk.tar.gz?AuthParam=1524031798_6f4ca6b2feabb1b0d36ed9157a44616f
JAVA_HOME=/usr/local/java
if [ ! -d "$JAVA_HOME" ];then
    mkdir $JAVA_HOME
fi

tar --strip-components 1 -xzvf jdk* -C $JAVA_HOME
cat << EOF >> /etc/profile
JAVA_HOME=/usr/local/java
JRE_HOME=$JAVA_HOME/jre
CLASS_PATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
export JAVA_HOME JRE_HOME CLASS_PATH PATH
EOF
source /etc/profile

-- 安装solr
wget https://mirrors.tuna.tsinghua.edu.cn/apache/lucene/solr/7.3.1/solr-7.3.1.zip
unzip solr-7.3.1.zip
sh install_solr_service.sh -d /opt/solr_data/ -i /opt/solr_install/ -p 8985 -s lcsolr
-- 拷贝conf
cp -rf /opt/solr_install/solr-7.3.1/server/solr/configsets/sample_techproducts_configs/conf/ /opt/solr_data/data/new_core

-- 安装lor
cd /home/setup
git clone https://github.com/sumory/lor
cd lor
make install

yum install -y unzip
#安装lualocks
wget https://luarocks.org/releases/luarocks-2.4.1.tar.gz
tar -xzvf luarocks-2.4.1.tar.gz
cd luarocks-2.4.1/
./configure --prefix=/usr/local/openresty/luajit \
    --with-lua=/usr/local/openresty/luajit/ \
    --lua-suffix=jit \
    --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1
make build
make install

# 安装luasocket
luarocks install luasocket

cat << EOF >> /etc/profile
export PATH=$PATH:/usr/local/openresty/luajit/bin
EOF
source /etc/profile

yum install -y libcurl-devel

luarocks install Lua-cURL --server=https://luarocks.org/dev

cd /etc/ld.so.conf.d
cat << EOF > app.conf
/usr/local/openresty/lualib 
EOF
ldconfig

