#!/usr/bin/env bash

# Update packages
echo "Running updates..."
yum -y update
echo "Installing epel ..."
yum -y install epel-release yum-utils
echo "Installing misc ..."
yum -y install vim curl unzip java-1.8.0-openjdk
sudo curl -Oq https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.26/mysql-connector-java-8.0.26-sources.jar
cp mysql-connector-java-8.0.26-sources.jar /opt/archivesspace/lib/
#download and install Apache Solr
#wget https://www.apache.org/dyn/closer.lua/lucene/solr/8.11.1/solr-8.11.1.tgz?action=download
#tar zxf solr-8.11.1.tgz
#systemctl start httpd
echo "Installing MariaDB ..."
yum -y install mariadb-server
systemctl start mariadb
systemctl status mariadb
# check to see if archivesspace database exist - if not create and import
if ! mysql -u root -e 'use archivesspace'; then
mysql -u root -e "create database archivesspace default character set utf8"
#mysql -u root archivesspace < /vagrant/utc.sql;
mysql -u root -e  "grant all on archivesspace.* to 'as'@'localhost' identified by 'as123'"
mysql -u root archivesspace < /vagrant/utc.sql
echo "Setting up database"
/opt/archivesspace/scripts/setup-database.sh
fi
# create systemd for archivesspace
cp -u /vagrant/archivesspace.service /etc/systemd/system/archivesspace.service
systemctl enable archivesspace.service
systemctl start archivesspace.service
systemctl status archivesspace.service
# finish messages
echo "USE"
echo "http://findingaids.local:8089/ – the backend"
echo "http://findingaids.local:8080/ – the staff interface"
echo "http://findingaids.local:8081/ – the public interface"
echo "http://findingaids.local:8082/ – the OAI-PMH server"
echo "http://findingaids.local:8090/ – the Solr admin console"
echo "It will take some time for interfaces to become available"
