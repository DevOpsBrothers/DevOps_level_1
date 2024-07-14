#!/bin/bash
set -ex

# STARTING_PORT=${JENKINS_PORT:-9080}
LOG_FILE="jenkins_${STARTING_PORT}.log"
> $LOG_FILE

/usr/local/sbin/dropbear &

java -Djava.awt.headless=true -version
java -Djava.awt.headless=true -jar jenkins1.war --httpPort=$JENKINS_PORT --logfile=$LOG_FILE &

tail -f $LOG_FILE
