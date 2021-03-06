# 新建安装包目录
setup_dir=/home/setup
if [ ! -d "$setup_dir" ];then
    mkdir $setup_dir
fi
cd $setup_dir

# 添加并更新源
echo 'install yum-utils'
yum install -y yum-utils
yum-config-manager --add-repo https://openresty.org/package/centos/openresty.repo
yum update -y

# 安装git
echo 'install git'
yum install -y git

# 安装openresty-resty 1.13.6
echo 'install openresty-resty 1.13.6'
yum install -y openresty-resty

# 下载openresty所需lib
git clone https://github.com/misschuer/tools.git
cd tools/lib
\cp -rf * /usr/local/openresty/lualib

groupadd resty
useradd -d /resty -g resty

cd $setup_dir
# 下载openresty-china的demo
git clone https://github.com/sumory/openresty-china.git

# 安装lor
git clone https://github.com/sumory/lor
cd lor
make install

#新建git仓库们的文件夹
git_dir=/home/gits
if [ ! -d "$git_dir" ];then
    mkdir $git_dir
fi
cd $git_dir

# 创建一个git仓库
git_name1=orchina
mkdir $git_name1.git
cd $git_name1.git
git init --bare

#新建项目
server_dir=/home/server
#新建文件夹
if [ ! -d "$server_dir" ];then
    mkdir $server_dir
fi
cd $server_dir
# 复制项目
git clone $git_dir/$git_name1
cd $git_name1
cp -r $setup_dir/openresty-china/* .
git add .
git commit -am "first commit"
git push origin master

# 把服务器的操作文件替换掉
cd $server_dir/$git_name1
\cp $setup_dir/tools/policed/start.sh .
\cp $setup_dir/tools/policed/reload.sh .
\cp $setup_dir/tools/policed/stop.sh .

# 新建静态文件夹
if [ ! -d "/data" ];then
    mkdir /data
fi

if [ ! -d "/data/openresty-china" ];then
    mkdir /data/openresty-china
fi

if [ ! -d "/data/openresty-china/static" ];then
    mkdir /data/openresty-china/static
fi

# 把静态文件拷进去
\cp -rf $server_dir/$git_name1/install/avatar/* /data/openresty-china/static
