#!/bin/bash
#启动mongodb
if [[ -z `ps -ef|grep mongod|grep -v grep|awk {'print $2'}` ]]; then
    echo 'start mongodb' 
    nohup mongod --dbpath=/data/mongodb --port 27017 --auth > /data/mongodb/log.out 2>&1 & 
    sleep 2
fi

#启动运维工具计划任务端
if [ -z `ps -ef|grep python|grep plan|grep -v grep|awk {'print $2'}` ]; then
    echo 'start python plan'
    nohup python -u /home/soft_mgr/src/soft_mgr_agent.py --action=plan --log_level=1 --db_port=27017 --db_user=dev --db_password=asdf --wulongju=0 > /home/log/plan.log 2>&1 &
fi

#启动运维工具终端
if [ -z `ps -ef|grep python|grep term|grep -v grep|awk {'print $2'}` ]; then
    echo 'start python term'
    myip="`ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'`"
    echo $myip
    nohup python -u /home/soft_mgr/src/soft_mgr_agent.py --action=term --log_level=1 --db_port=27017 --db_user=dev --db_password=asdf --domain=$myip --game_db_str=HgAAAByUz/iLLPzag5dTbXDweHfSrMv/ZEW0uzthZG1pbgA= --wulongju=0 > /home/log/term.log 2>&1 &
fi

