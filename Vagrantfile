# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  #config.vm.box = "hashicorp/precise32"
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "forwarded_port", guest: 3306, host: 3306
  config.vm.network "forwarded_port", guest: 4567, host: 4567
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 8081, host: 8081
  config.vm.network "forwarded_port", guest: 8089, host: 8089
  config.vm.network "forwarded_port", guest: 8443, host: 8443
  config.vm.network "forwarded_port", guest: 8983, host: 8983
  #config.vm.network "public_network", ip: "10.52.80.3", mac: "F8B156C6831E"

# default router
#config.vm.provision "shell",
 # run: "always",
  #inline: "route add default gw 10.52.242.1"

# default router ipv6
#config.vm.provision "shell",
 # run: "always",
  #inline: "route -A inet6 add default gw fc00::1 eth1"

# delete default gw on eth0
#config.vm.provision "shell",
 # run: "always",
  #inline: "eval `route -n | awk '{ if ($8 ==\"eth0\" && $2 != \"0.0.0.0\") print \"route del default gw \" $2; }'`"

  config.vm.provider "virtualbox" do |vb|
     vb.memory = "2048"
  end

  #config.vm.provision "shell", path:"setup_python.sh"
  config.vm.provision "shell", path:"setup_mysql.sh"
  config.vm.provision "shell", path:"setup_archivesspace.sh"
  #config.vm.provision "shell", path:"update_db.sh"

end
