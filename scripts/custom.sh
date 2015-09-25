#!/bin/bash

SHARED_DIR=$1
if [ -f "$SHARED_DIR/configs/variables" ]; then
  . "$SHARED_DIR"/configs/variables
fi

echo "Installing Drupal themes" 
cd "$DRUPAL_HOME"/sites/all
if [ ! -d themes ]; then
  mkdir themes
fi

cd "$DRUPAL_HOME"/sites/all/themes
while read LINE; do
	set -- $LINE 
	git clone $1 $2
	cd $2
	#Do we need the following line for each theme?
	git config core.filemode false
	cd "$DRUPAL_HOME"/sites/all/themes
done < "$SHARED_DIR"/configs/islandora-theme-list-umlso.txt

# Create ctools/css and set permissions
cd "$DRUPAL_HOME"/sites/all
mkdir -p files/ctools/css 
chmod 777 files/ctools/css

echo "Installing Drupal contrib modules" 
cd "$DRUPAL_HOME"/sites/all/modules
drush -y dl job_scheduler i18n admin_menu advanced_help block_class entity entityreference exclude_node_title extlink feeds git_deploy image_link_formatter linkchecker securelogin views_slideshow views_slideshow_galleria openid_selector

# Install openid-selector in libraries directory
cd "$DRUPAL_HOME"/sites/all/libraries
wget https://openid-selector.googlecode.com/files/openid-selector-1.3.zip
unzip openid-selector-1.3.zip
rm openid-selector-1.3.zip
cd "$DRUPAL_HOME"/sites/all/modules

# Enable the modules
drush -y en i18n admin_menu job_scheduler advanced_help block_class entity entityreference exclude_node_title extlink feeds git_deploy image_link_formatter linkchecker views_slideshow views_slideshow_galleria openid_selector
# Need ssl configured for this to work; ignore for now
# drush en securelogin

# Disable toolbar module b/c it conflicts with admin_menu
 drush -y dis toolbar overlay
 
# Suppress error about ServerName 
sudo echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Setup multi-site 
#site_arr=( lso merlin mospace mst mu umkc umsl ) 
#for i in "${site_arr[@]}"
#do
#	drush si -y --db-url=mysql://root:islandora@localhost/"$i" --sites-subdir="$i" --site-name="example.org/$i"
#done
# Each site-install sets the admin password. Set it once at the end: 
#drush user-password admin --password=islandora



#https://www.drupal.org/node/823990
# Setup /etc/hosts 
#sudo echo "127.0.0.1 testsite.localhost" >> /etc/hosts 

# Setup Virtual Hosts (apache)
#/etc/apache2/httpd.conf -> (ubuntu)/etc/apache2/sites-available/000-default.conf

# Restart apache2 
#service apache2 restart 

# Setup database for testsite (MYSQL)


# Setup sites folders 
# Assert default/files exists 
#cd "$DRUPAL_HOME"/sites/
#if [ ! -d default/files ]; then  
#	sudo mkdir -pm 777 default/files 
#fi

# Use sites/default as the template for the new sites 
#sudo cp -a default testsite.localhost




