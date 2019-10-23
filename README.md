# Vagrant DevMachine

## Components

* Apache2
* Maria db 10.3
* Php 7.3
* NodeJS 10
* Git
* yarn
* Samba 

## Requirements

* Vagrant > 1.9
* Virtualbox > 5.1

## Install


Navigate to project directory and edit `artyom.yaml` with your proper IP and shared directory. Then :

 `vagrant up`
 
 In case of rsync errors :
 
 `vagrant plugin install vagrant-vbguest`
