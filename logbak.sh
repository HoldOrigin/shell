#切割ｎｇｉｎｘ日志
#crontab -e
#03 03 * * 5 logbak.sh   //周五０３：０３执行脚本切割日志
#!/bin/bash
date=`date +%Y%m%d`
logpath=/usr/local/nginx/logs
mv $logpath/access.log $logpath/access-$date.log
mv $logpath/error.log $logpath/error-$date.log
kill -USR1 $(cat $logpath/nginx.pid)
