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
sudo apt update -y
sudo apt install apache2 apache2-utils

#mariadb
sudo apt-get install -y mariadb-server mariadb-client

#php
sudo apt install php7.3 php7.3-cli php7.3-curl php7.3-gd php7.3-intl php7.3-json php7.3-mbstring php7.3-mysql php7.3-opcache php7.3-readline php7.3-xml php7.3-xsl php7.3-zip php7.3-bz2 libapache2-mod-php7.3 php7.3-zip -y

#nodejs
sudo curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
sudo apt-get install -y nodejs
sudo apt-get install -y build-essential

#git
sudo apt-get install git

#user
sudo useradd -m -p $(openssl passwd -1 root) orwell
sudo usermod -aG sudo orwell
sudo usermod -s /bin/bash orwell
sudo sed -i "s/^PasswordAuthentication no$/PasswordAuthentication yes/" /etc/ssh/sshd_config 
sudo service sshd restart

#yarn
curl -o- -L https://yarnpkg.com/install.sh | bash


#initial config
sudo rm -rf /home/orwell/.bashrc
sudo cp -rf /home/vagrant/.bashrc /home/orwell/.bashrc
sudo cp -rf /home/vagrant/.yarn /home/orwell/.yarn