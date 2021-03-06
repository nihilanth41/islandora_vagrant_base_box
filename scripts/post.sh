#!/bin/bash

# Setup a user for Tomcat Manager
sed -i '$i<user username="islandora" password="islandora" roles="manager-gui"/>' /etc/tomcat6/tomcat-users.xml
service tomcat6 restart

# Set correct permissions on sites/default/files
chmod -R 775 /var/www/drupal/sites/default/files
