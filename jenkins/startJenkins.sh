STARTING_PORT=9080
LOG_FILE="jenkins_${STARTING_PORT}.log"
/usr/local/bin/sshd -D&

java -jar jenkins.war --httpPort=$JENKINS_PORT --logfile=$LOG_FILE

