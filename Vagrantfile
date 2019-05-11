# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

VAGRANTFILE_API_VERSION ||= "2"
confDir = $confDir ||= File.expand_path(File.dirname(__FILE__))

ArtyomYamlPath = confDir + "/artyom.yaml"

afterScriptPath = confDir + "/after.sh"

require File.expand_path(File.dirname(__FILE__) + '/scripts/artyom.rb')

Vagrant.require_version '>= 1.9.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    if File.exist? ArtyomYamlPath then
        settings = YAML::load(File.read(ArtyomYamlPath))
    else
        abort "Artyom settings file not found in #{confDir}"
    end

    Artyom.configure(config, settings)

    if File.exist? afterScriptPath then
        config.vm.provision "shell", path: afterScriptPath, privileged: false
    end

    if defined? VagrantPlugins::HostsUpdater
        config.hostsupdater.aliases = settings['sites'].map { |site| site['map'] }
    end
end