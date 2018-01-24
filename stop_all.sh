# kill mongodb
mid=`ps -ef|grep mongod|grep -v grep|awk {'print $2'}`
if !([ -z "$mid" ];) then
    echo "killed mongod", $mid
    kill $mid 
fi

#kill 运维工具计划任务端
mid=`ps -ef|grep python|grep plan|grep -v grep|awk {'print $2'}`
if !([ -z "$mid" ];) then
    echo "killed python plan", $mid
    kill $mid 
fi

#kill 运维工具终端
mid=`ps -ef|grep python|grep term|grep -v grep|awk {'print $2'}`
if !([ -z "$mid" ];) then
    echo "killed python term", $mid
    kill $mid 
fi

#关闭中心服
mid=`ps -ef|grep centd|grep -v grep|awk {'print $2'}`
if !([ -z "$mid" ];) then
    echo "killed centd", $mid
    kill $mid 
fi


#关闭网关服
mid=`ps -ef|grep netgd|grep -v grep|awk {'print $2'}`
if !([ -z "$mid" ];) then
    echo "killed netgd", $mid
    kill $mid 
fi

#清空数据
#rm -rf /home/game_test/data/*
#rm -rf /home/game_test/log/*
#echo "remove /home/game_test/data/*"
