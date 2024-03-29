sudo apt-get update && apt-get upgrade -y

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

wget -q https://packages.sury.org/php/apt.gpg -O- | sudo apt-key add -
echo "deb https://packages.sury.org/php/ stretch main" | sudo tee /etc/apt/sources.list.d/php.list

sudo apt update -y

sudo apt-get install -y software-properties-common dirmngr
sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mirrors.dotsrc.org/mariadb/repo/10.3/debian stretch main'

#apache
echo "Installing apache2..."
sudo apt update -y
sudo apt install apache2 apache2-utils
sudo service apache2 stop
sudo mv -f /etc/apache2/sites-availables/000-default.conf /etc/apache2/sites-availables/000-default.conf.back
sudo mv -f /etc/apache2/apache2.conf /etc/apache2/apache2.conf.back
echo "Installing apache2... DONE"

#mariadb
echo "Installing mariadb..."
sudo apt-get install -y mariadb-server mariadb-client
echo "Installing mariadb... DONE"

#php
echo "Installing php..."
sudo apt install php7.3 php7.3-cli php7.3-curl php7.3-gd php7.3-intl php7.3-json php7.3-mbstring php7.3-mysql php7.3-opcache php7.3-readline php7.3-xml php7.3-xsl php7.3-zip php7.3-bz2 libapache2-mod-php7.3 php7.3-zip -y
echo "Installing php... DONE"

#nodejs
echo "Installing nodeJS..."
sudo curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
sudo apt-get install -y nodejs
sudo apt-get install -y build-essential
echo "Installing nodeJS... DONE"

#git
echo "Installing git..."
sudo apt-get -y install git
echo "Installing git... DONE"

#samba
echo "Installing samba..."
sudo apt-get -y install samba 
sudo /etc/init.d/samba stop
sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.back
echo "Installing samba... DONE"

#user
sudo useradd -m -p $(openssl passwd -1 root) orwell
sudo usermod -aG sudo orwell
sudo usermod -s /bin/bash orwell
sudo sed -i "s/^PasswordAuthentication no$/PasswordAuthentication yes/" /etc/ssh/sshd_config 
sudo service sshd restart

#yarn
curl -o- -L https://yarnpkg.com/install.sh | bash

#initial config
echo "Processing initial config..."
sudo rm -rf /home/orwell/.bashrc
sudo mv -f /home/vagrant/.bashrc /home/orwell/.bashrc
sudo mv -f /home/vagrant/.yarn /home/orwell/.yarn
sudo mv -f /home/vagrant/smb.conf /etc/samba/smb.conf
sudo mkdir /opt/shared
sudo chmod -R 777 /opt/shared
sudo mv -f /home/vagrant/000-default.conf /etc/apache2/sites-availables/000-default.conf
sudo mv -f /home/vagrant/apache2.conf /etc/apache2/apache2.conf
sudo service apache2 restart
sudo /etc/init.d/samba start
echo "Processing initial config... DONE"