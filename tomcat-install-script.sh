#!/bin/bash
# author name is missing.
TOMCAT_URL="https://www-eu.apache.org/dist/tomcat/tomcat-8/v8.5.43/bin/apache-tomcat-8.5.43.tar.gz"

function check_java_home {
    if [ -z ${JAVA_HOME} ]
    then
        echo 'Could not find JAVA_HOME. Please install Java and set JAVA_HOME'
	exit
    else 
	echo 'JAVA_HOME found: '$JAVA_HOME
        if [ ! -e ${JAVA_HOME} ]
        then
	    echo 'Invalid JAVA_HOME. Make sure your JAVA_HOME path exists'
	    exit
        fi
    fi
}

echo 'Installing tomcat server...'
echo 'Checking for JAVA_HOME...'
check_java_home

echo 'Downloading tomcat-8.5...'
if [ ! -f /etc/apache-tomcat-8*tar.gz ]
then
    curl -O $TOMCAT_URL
fi
echo 'Finished downloading...'

echo 'Creating install directories...'
sudo mkdir -p '/opt/tomcat/8_5'

if [ -d "/opt/tomcat/8_5" ]
then
    echo 'Extracting binaries to install directory...'
    sudo tar xzf apache-tomcat-8*tar.gz -C "/opt/tomcat/8_5" --strip-components=1
    echo 'Creating tomcat user group...'
    sudo groupadd tomcat
    sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
    
    echo 'Setting file permissions...'
    cd "/opt/tomcat/8_5"
    sudo chgrp -R tomcat "/opt/tomcat/8_5"
    sudo chmod -R g+r conf
    sudo chmod -R g+x conf

    # This should be commented out on a production server
    sudo chmod -R g+w conf

    sudo chown -R tomcat webapps/ work/ temp/ logs/

    echo 'Setting up tomcat service...'
    sudo touch tomcat.service
    sudo chmod 777 tomcat.service 
    echo "[Unit]" > tomcat.service
    echo "Description=Apache Tomcat Web Application Container" >> tomcat.service
    echo "After=network.target" >> tomcat.service

    echo "[Service]" >> tomcat.service
    echo "Type=forking" >> tomcat.service

    echo "Environment=JAVA_HOME=$JAVA_HOME" >> tomcat.service
    echo "Environment=CATALINA_PID=/opt/tomcat/8_5/temp/tomcat.pid" >> tomcat.service
    echo "Environment=CATALINA_HOME=/opt/tomcat/8_5" >> tomcat.service
    echo "Environment=CATALINA_BASE=/opt/tomcat/8_5" >> tomcat.service
    echo "Environment=CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC" >> tomcat.service
    echo "Environment=JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom" >> tomcat.service

    echo "ExecStart=/opt/tomcat/8_5/bin/startup.sh" >> tomcat.service
    echo "ExecStop=/opt/tomcat/8_5/bin/shutdown.sh" >> tomcat.service

    echo "User=tomcat" >> tomcat.service
    echo "Group=tomcat" >> tomcat.service
    echo "UMask=0007" >> tomcat.service
    echo "RestartSec=10" >> tomcat.service
    echo "Restart=always" >> tomcat.service

    echo "[Install]" >> tomcat.service
    echo "WantedBy=multi-user.target" >> tomcat.service

    sudo mv tomcat.service /etc/systemd/system/tomcat.service
    sudo chmod 755 /etc/systemd/system/tomcat.service
    sudo systemctl daemon-reload
    
    echo 'Starting tomcat server....'
    sudo systemctl start tomcat
    exit
else
    echo 'Could not locate installation direcotry..exiting..'
    exit
fi
