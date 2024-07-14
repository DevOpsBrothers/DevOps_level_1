set -ex
STARTING_PORT=9080
echo "current dir: `pwd` | hostname : `hostname -i` | `ls -1`"
LOG_FILE="jenkins_${STARTING_PORT}.log"
> $LOG_FILE
/usr/local/sbin/dropbear&

java -version
java -jar jenkins.war --httpPort=$JENKINS_PORT --logfile=$LOG_FILE &

tail -f $LOG_FILE


