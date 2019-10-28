#!/bin/bash
redis_home=/usr/local
redis_log=/var/log
redis_dump=/var/lib/redis/6379
redis_conf=/etc/redis
redis_pid=/var/run
IP=`ifconfig |awk 'NR==2{print $2}'`
#redis_passwd=`date +%s |sha256sum |base64 |head -c 10 ;echo`
#export PATH=$PATH:$redis_home/bin
cd /root/
if [ ! -d redis-4.0.8 ] ;then
tar -zxf redis-4.0.8.tar.gz
fi
cd /root/redis-4.0.8/
make && make  install  &> /dev/null
echo "编译完成!config"
mkdir -p $redis_dump 
mkdir /etc/redis 
echo "ADD script and configuration file"
cd $redis_conf

cp /root/redis-4.0.8/redis.conf /etc/redis/redis.conf
if [ $? -eq 0 ] ;then
 sed -i '69c bind '$IP'' redis.conf
 sed -i '136s/no/yes/' redis.conf
 sed -i '171c logfile '$redis_log'/redis_6379.log' redis.conf
 sed -i '263c dir '$redis_dump'' redis.conf
 sed -i '814s/#//' redis.conf
 sed -i '822s/#//' redis.conf
 sed -i '828c cluster-node-timeout 5000' redis.conf
else
 echo "copy confile failed!"
fi
#启动脚本
cp /root/redis-4.0.8/utils/redis_init_script /etc/init.d/redis
sed -i  '11c CONF="/etc/redis/redis.conf"' /etc/init.d/redis
sed -i '30c \           \$CLIEXEC -h '$IP' -p 6379 shutdown' /etc/init.d/redis
/etc/init.d/redis start
killall -0 redis-server
if [ $? -eq 0 ] ; then
 echo "server is ok"
else
 echo "server is failed"
 /etc/init.d/redis stop
 /etc/init.d/redis start
fi
#mkdir $redis_conf  $redis_dump 
#cd $redis_conf && touch redis.conf
#cat /dev/null >redis.conf
#IP=`ifconfig |awk 'NR==2{print $2}'`
#echo "vm.overcommit_memory = 1" >> /etc/sysctl.conf && sysctl -p
#echo "daemonize yes" >> redis.conf
#echo "bind $IP" >>redis.conf
#echo "maxmemory 1024mb" >>redis.conf
#echo "pidfile $redis_pid/redis_6379.pid" >>redis.conf
#echo "port 6379" >>redis.conf
#echo "tcp-keepalive 0" >>redis.conf
#echo "loglevel notice" >>redis.conf
#echo "logfile "$redis_log"/redis.log" >>redis.conf
#echo "databases 16" >>redis.conf
#echo "rdbcompression yes" >>redis.conf
#echo "dbfilename dump.rdb" >>redis.conf
#echo "dir $redis_dump" >>redis.conf
#echo "stop-writes-on-bgsave-error yes" >>redis.conf
#echo "requirepass $redis_passwd" >>redis.conf
#echo "save 60 1000" >>redis.conf
#执行配置文件中的参数
#$redis_home/bin/redis-server $redis_conf/redis.conf
#echo "Redis password is $redis_passwd"
####################################################
#设置/etc/ini.d/redis
#cp /root/redis-4.0.8/utils/redis_init_script /etc/init.d/redis
