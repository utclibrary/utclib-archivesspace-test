#!/usr/bin/env bash

# Update packages
echo "Running updates..."
yum -y update
echo "Installing epel ..."
yum -y install epel-release yum-utils
echo "Installing misc ..."
yum -y install vim curl unzip wget java-1.8.0-openjdk
#sudo curl -Oq https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.29/mysql-connector-java-8.0.29.jar
cp /vagrant/mysql-connector-java-8.0.30.jar /opt/archivesspace/lib/
rm -rf /opt/archivesspace/data/indexer_state
rm -rf /opt/archivesspace/data/indexer_pui_state
#download and install Apache Solr
## echo "Installing Apache Solr ..."
yum -y install lsof
wget -c https://archive.apache.org/dist/lucene/solr/8.10.0/solr-8.10.0.tgz
sudo tar xzf solr-8.10.0.tgz solr-8.10.0/bin/install_solr_service.sh --strip-components=2
sudo ./install_solr_service.sh solr-8.10.0.tgz
##
sudo mkdir -p /opt/solr/server/solr/configsets/archivesspace/conf
##
cp /vagrant/schema.xml /opt/solr/server/solr/configsets/archivessapce/conf
cp /vagrant/solrconfig.xml /opt/solr/server/solr/configsets/archivessapce/conf
touch cp /opt/solr/server/solr/configsets/archivessapce/conf/stopwords.txt
touch cp /opt/solr/server/solr/configsets/archivessapce/conf/synonyms.txt
/opt/solr/bin/solr start
/opt/solr/bin/solr create -c archivessapce -d archivesspace
service solr status
#systemctl start httpd
#echo "Installing MariaDB ..."
#wget https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
#chmod +x mariadb_repo_setup
#sudo ./mariadb_repo_setup
#sudo yum install MariaDB-server
#yum -y install mariadb-server
#systemctl start mariadb
#systemctl status mariadb
 # check to see if archivesspace database exist - if not create and import
## #if ! mysql -u root -e 'use archivesspace'; then
#mysql -u root -e "create database archivesspace default character set utf8mb4"
 #mysql -u root archivesspace < /vagrant/utc.sql;
#mysql -u root -e  "grant all on archivesspace.* to 'as'@'localhost' identified by 'as123'"
#mysql -u root archivesspace < /vagrant/utc.sql
echo "Setting up database"
/opt/archivesspace/scripts/setup-database.sh
#fi
#systemctl restart mariadb
# create systemd for archivesspace
cp -u /vagrant/archivesspace.service /etc/systemd/system/archivesspace.service
systemctl enable archivesspace.service
systemctl start archivesspace.service
systemctl status archivesspace.service
sudo setenforce 0
# finish messages
echo "USE"
echo "http://findingaids.local:8089/ – the backend"
echo "http://findingaids.local:8080/ – the staff interface"
echo "http://findingaids.local:8081/ – the public interface"
echo "http://findingaids.local:8082/ – the OAI-PMH server"
echo "http://findingaids.local:8983/solr – the Solr admin console"
echo "It will take some time for interfaces to become available"
