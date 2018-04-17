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
yum install -y gcc
redis=redis-4.0.6
wget http://download.redis.io/releases/$redis.tar.gz
tar xzvf $redis.tar.gz
cd $redis
make MALLOC=libc
cd src && make install

# 配置redis启动环境
mkdir /etc/redis
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
