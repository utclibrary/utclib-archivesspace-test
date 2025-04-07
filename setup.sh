#!/usr/bin/env bash
solr_version="9.4.1"
# Update and install packages
dnf -y update
dnf -y install epel-release yum-utils vim curl unzip wget java-17-openjdk lsof mysql-server

cp /vagrant/mysql-connector-java-8.0.30.jar /opt/archivesspace/lib/
# echo '192.168.56.15 findingaids.local' >> /etc/hosts
rm -rf /opt/archivesspace/data/indexer_state
rm -rf /opt/archivesspace/data/indexer_pui_state
##download and install Apache Solr
#wget -c https://archive.apache.org/dist/lucene/solr/8.11.2/solr-8.11.2.tgz
cp /vagrant/solr-$solr_version.tgz .
#
tar xzf solr-$solr_version.tgz solr-$solr_version/bin/install_solr_service.sh --strip-components=2
./install_solr_service.sh solr-$solr_version.tgz
#
cp -R /vagrant/conf /opt/solr-$solr_version/server/solr/configsets/archivesspace/

chown -R solr:solr /opt/solr-$solr_version/server/solr/configsets/archivesspace/conf
service solr stop
#
sudo -u solr /opt/solr/bin/solr start
sudo -u solr /opt/solr/bin/solr create -c archivesspace -d archivesspace
chown -R solr:solr /opt/solr-$solr_version/server/solr/configsets/archivesspace/conf
##sudo -u solr /opt/solr/bin/solr stop
sed 's/#SOLR_JETTY_HOST="127.0.0.1"/SOLR_JETTY_HOST="0.0.0.0"/' /opt/solr-$solr_version/bin/solr.in.sh
service jetty restart
#
#
service solr start
service solr status

echo "Installing MySQL ..."
systemctl enable --now mysqld
systemctl status mysqld
# check to see if archivesspace database exist - if not create and import
## #if ! mysql -u root -e 'use archivesspace'; then
mysql -u root -e "create database archivesspace default character set utf8mb4"
mysql -u root archivesspace < /vagrant/utc.sql
mysql -u root -e "CREATE USER 'as'@'%' identified by 'as123'"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* to 'as'@'%' WITH GRANT OPTION"
mysql -u root -e "FLUSH PRIVILEGES"
mysql -u root -e "FlUSH TABLES"
echo "Setting up database"
/opt/archivesspace/scripts/setup-database.sh
#fi
systemctl restart mysqld
systemctl status mysqld
/opt/archivesspace/archivesspace.sh start
setenforce 0
# finish messages
echo "USE"
echo "http://localhost:8089/ – the backend"
echo "http://localhost:8080/ – the staff interface"
echo "http://localhost:8081/ – the public interface"
echo "http://localhost:8082/ – the OAI-PMH server"
echo "http://localhost:8983/solr – the Solr admin interface"
echo "It will take some time for interfaces to become available"
