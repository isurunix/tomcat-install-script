# tomcat-install-script
Bash script to download and install Apache Tomcat server.  

This is a simple script to download and install tomcat server on Ubuntu.  
Since this is a BASH script this should work on most of the Linux distribution with BASH.  
But I've only tested this on Ubuntu 16.04. Feel free to test this on other distributions and you are welcome to fork this and
tweak this.

# Dependencies

1. Bash
2. curl

# Supported Distributions

This list outs the distributions the script was tested on and worked successfully. You are welcome to add your test results here.

1. Ubuntu 16.04

# Notes

After running the script you need to create tomcat user accounts with proper roles to use this in a developer enviorenment. This script only install tomcat server as a service on your Ubuntu system.

# References
https://www.digitalocean.com/community/tutorials/how-to-install-apache-tomcat-8-on-ubuntu-16-04

