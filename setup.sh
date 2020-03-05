#!/usr/bin/env bash

# Update packages
echo "Running yum update..."
yum -y update
echo "Installing epel ..."
yum -y install epel-release yum-utils
echo "Installing misc ..."
yum -y install vim curl unzip java-1.8.0-openjdk sendmail git nginx
systemctl start nginx
#systemctl start httpd
echo "Installing MariaDB ..."
yum -y install mariadb-server
systemctl start mariadb
systemctl status mariadb
# check to see if archivesspace database exist - if not create and import
#if ! mysql -u root -e 'use archivesspace'; then
mysql -u root -e "create database archivesspace default character set utf8"
#mysql -u root archivesspace < /vagrant/utc.sql;
mysql -u root -e  "grant all on archivesspace.* to 'as'@'localhost' identified by 'as123'"
gunzip /vagrant/utc.sql.gz
mysql -u root archivesspace < /vagrant/utc.sql
echo "Setting up database"
/opt/archivesspace/scripts/setup-database.sh
#fi
#change admin pw to 'admin'
mysql -u root -e 'UPDATE archivesspace.auth_db SET pwhash = "$2a$10$X72U4CR.7sW8YDrxnNEO/etMF37b9MvX7Mynl5mb4X1lOTBZnKgb2" WHERE username = "admin"'
# install aspace-import-excel plugin
# /opt/archivesspace/scripts/initialize-plugin.sh aspace-import-excel
# create systemd for archivesspace
# cp -u /vagrant/archivesspace.service /etc/systemd/system/archivesspace.service
# systemctl enable archivesspace.service
# systemctl start archivesspace.service
# systemctl status archivesspace.service
/opt/archivesspace/archivesspace.sh start
# finish messages
echo "USE"
echo "http://192.168.33.11:8089/ – the backend"
echo "http://192.168.33.11:8080/ – the staff interface UN:admin PW:admin"
echo "http://192.168.33.11:8081/ – the public interface"
echo "http://192.168.33.11:8082/ – the OAI-PMH server"
echo "http://192.168.33.11:8090/ – the Solr admin console"
echo "It will take some time for interfaces to become available"
