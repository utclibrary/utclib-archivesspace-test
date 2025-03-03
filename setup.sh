#!/usr/bin/env bash

# Update and install packages
dnf -y update
dnf -y install epel-release yum-utils vim curl unzip wget java-1.8.0-openjdk lsof mysql-server

cp /vagrant/mysql-connector-java-8.0.30.jar /opt/archivesspace/lib/

rm -rf /opt/archivesspace/data/indexer_state
rm -rf /opt/archivesspace/data/indexer_pui_state
#download and install Apache Solr
wget -c https://archive.apache.org/dist/lucene/solr/8.11.2/solr-8.11.2.tgz
cp /vagrant/solr-8.11.2.tgz .

tar xzf solr-8.11.2.tgz solr-8.11.2/bin/install_solr_service.sh --strip-components=2
./install_solr_service.sh solr-8.11.2.tgz -f

cp -r /vagrant/conf /opt/solr-8.11.2/server/solr/configsets/archivesspace/

#chown -R solr:solr /opt/solr-8.11.2/server/solr/configsets/archivesspace/conf
#service solr stop

#sudo -u solr /opt/solr/bin/solr start
sudo -u solr /opt/solr/bin/solr create -c archivesspace -d archivesspace -force
#sudo -u solr /opt/solr/bin/solr stop


#service solr start
service solr status

#echo "Installing MariaDB ..."
systemctl enable --now mysqld
systemctl status mysqld
 # check to see if archivesspace database exist - if not create and import
## #if ! mysql -u root -e 'use archivesspace'; then
mysql -u root -e "create database archivesspace default character set utf8mb4"
mysql -u root archivesspace < /vagrant/utc.sql;
mysql -u root -e "CREATE USER 'as'@'localhost' identified by 'as123'"
mysql -u root -e "GRANT ALL PRIVILEGES on archivesspace.* to 'as'@'localhost' WITH GRANT OPTION"
mysql -u root -e "FLUSH PRIVILEGES"
echo "Setting up database"
/opt/archivesspace/scripts/setup-database.sh
#fi
systemctl restart mysqld
systemctl status mysqld
/opt/archivesspace/archivesspace.sh start
sudo setenforce 0
# finish messages
echo "USE"
echo "http://findingaids.local:8089/ – the backend"
echo "http://findingaids.local:8080/ – the staff interface"
echo "http://findingaids.local:8081/ – the public interface"
echo "http://findingaids.local:8082/ – the OAI-PMH server"
echo "http://findingaids.local:8983/solr – the Solr admin console"
echo "It will take some time for interfaces to become available"
