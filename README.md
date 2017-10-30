# utclib-archivesspace-test
UTC ArchivesSpace Vagrant Setup

1. Install VirtualBox https://www.virtualbox.org/wiki/Downloads (no later than 5.1)
2. Install Vagrant https://www.vagrantup.com/
3. Install Git https://git-scm.com/ (we will use git bash - use CTRL+SHIFT+INS to paste)
4. From Git Bash, Clone the repo (git clone https://github.com/utclibrary/utclib-archivesspace-test )
5. Ensure that latest utc.sql or utc.sql.gz dump is copied to the folder (if not, empty db will load - log in with admin:admin)
6. cd utclib-archivesspace-test
7. vagrant up

It can take about 5 minutes for the Archivesspace software to load on the system.

Navigate to http://localhost:8080 and keep refreshing for Staff Interface

http://localhost:8089/ – the backend

http://localhost:8080/ – the staff interface

http://localhost:8081/ – the public interface

>Based on https://github.com/djpillen/archivagrant
