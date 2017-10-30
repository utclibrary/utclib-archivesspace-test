#!/usr/bin/env bash

echo "Installing dependencies"
apt-get -y updateun
apt-get -y install openjdk-7-jre-headless
apt-get -y install unzip
#apt-get -y install git
apt-get -y install curl

echo "Downloading latest ArchivesSpace release"
mkdir /aspace
mkdir /aspace/zips
cd /aspace/zips
wget https://github.com/archivesspace/archivesspace/releases/download/v2.2.0/archivesspace-v2.2.0.zip
cd /aspace
unzip -o /aspace/zips/archivesspace-v2.2.0.zip
chown -R vagrant:vagrant /aspace

# These variables will be used to edit the ArchivesSpace config file to use the correct database URL and setup our plugins
DBURL='AppConfig[:db_url] = "jdbc:mysql://localhost:3306/archivesspace?user=as\&password=as123\&useUnicode=true\&characterEncoding=UTF-8"'
BROWSEURL='AppConfig[:browse_page_db_url] = "jdbc:mysql://localhost:3306/browse_pages?user=as\&password=as123\&useUnicode=true\&characterEncoding=UTF-8"'
#PLUGINS="AppConfig[:plugins] = ['bhl_browse_pages', 'timewalk', 'bhl_aspace_translations', 'bhl-ead-importer','bhl-ead-exporter','aspace-jsonmodel-from-format','donor_details', 'generate_bhl_identifiers']"
PUBLIC="AppConfig[:enable_public] = true"
FRONTEND="AppConfig[:enable_frontend] = true"

echo "Installing mysql java connector"
# http://archivesspace.github.io/archivesspace/user/running-archivesspace-against-mysql/
cd /aspace/archivesspace/lib
#wget http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.39/mysql-connector-java-5.1.39.jar
curl -Oq http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.39/mysql-connector-java-5.1.39.jar

echo "Editing config"
cd /aspace/archivesspace/config

# Edit the config file to use the MySQL database, setup our plugins, and disable the public and staff interfaces
# http://stackoverflow.com/questions/14643531/changing-contents-of-a-file-through-shell-script
sed -i "s@#AppConfig\[:db_url\].*@$DBURL@" config.rb
sed -i "s@#AppConfig\[:plugins\].*@$PLUGINS@" config.rb
sed -i "s@#AppConfig\[:enable_public\].*@$PUBLIC@" config.rb
sed -i "s@#AppConfig\[:enable_frontend\].*@$FRONTEND@" config.rb

#echo $DBURL >> config.rb

echo "Setting up database and starting ArchivesSpace"
# First, make the setup-database.sh and archivesspace.sh scripts executable
cd /aspace/archivesspace/scripts
chmod +x setup-database.sh
cd /aspace/archivesspace
chmod +x archivesspace.sh

echo "Import UTC db"
mysql --user=as --password=as123 archivesspace < /vagrant/db/utc.sql

echo "Setting up database"
scripts/setup-database.sh

#echo "Adding ArchivesSpace to system startup"
#cd /etc/init.d
#ln -s /aspace/archivesspace/archivesspace.sh archivesspace

#update-rc.d archivesspace defaults
#update-rc.d archivesspace enable

cd /aspace/archivesspace

echo "Starting ArchivesSpace"
./archivesspace.sh start

echo "All done!"
echo "Set up ArchivesSpace defaults (or import an ASpace mysql dump) and point your host machine's browser to http://localhost:8080 to begin using ArchivesSpace"
echo "Use vagrant ssh to access the virtual machine"
