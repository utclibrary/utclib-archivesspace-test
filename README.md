# utclib-archivesspace-test
UTC ArchivesSpace Vagrant Setup

1. Install VirtualBox https://www.virtualbox.org/wiki/Downloads (no later than 5.1)
1. Install Vagrant https://www.vagrantup.com/
1. Install Git https://git-scm.com/ (we will use git bash - use CTRL+SHIFT+INS to paste)
1. Clone or update a local of https://github.com/utclibrary/archivesspace-utc (to apply custom template)
1. Download current production version of AS from https://github.com/archivesspace/archivesspace/releases/ into ~/archivesspace
1. From Git Bash, Clone the repo (git clone https://github.com/utclibrary/utclib-archivesspace-test )
1. Ensure that latest utc.sql or utc.sql.gz dump is copied to the folder (if not, empty db will load - log in with admin:admin)
1. cd utclib-archivesspace-test
1. vagrant up

It can take about 5 minutes for the Archivesspace software to load on the system after vagrant shows system as ready.

Navigate to (in order of availability):

http://findingaids.local:8089 OR http://192.168.56.11:8089 - backend

http://findingaids.local:8983/solr OR http://192.168.56.11:8983/solr – Solr admin

http://findingaids.local:8080 OR http://192.168.56.11:8080 – staff interface

http://findingaids.local:8081 OR http://192.168.56.11:8081– public interface

http://findingaids.local:8082 OR http://192.168.56.11:8082– OAI-PMH server

>Based on https://github.com/djpillen/archivagrant
