class Artyom
    def Artyom.configure(config, settings)
        # Set The VM Provider
        ENV['VAGRANT_DEFAULT_PROVIDER'] = settings["provider"] ||= "virtualbox"

        # Configure Local Variable To Access Scripts From Remote Location
        scriptDir = File.dirname(__FILE__)

        # Prevent TTY Errors
        config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

        # Allow SSH Agent Forward from The Box
        config.ssh.forward_agent = true

        # Configure The Box
        config.vm.define settings["name"] ||= "artyom"
        config.vm.box = settings["box"] ||= "debian/stretch64"
		config.vm.box_url = "https://vagrantcloud.com/debian/stretch64"


        # Configure A public Network IP
        config.vm.network "public_network" , ip: settings["ip"]
		
		        # Configure A Few VirtualBox Settings
        config.vm.provider "virtualbox" do |vb|
            vb.name = settings["name"] ||= "artyom"
            vb.customize ["modifyvm", :id, "--memory", settings["memory"] ||= "4096"]
            vb.customize ["modifyvm", :id, "--cpus", settings["cpus"] ||= "2"]
            vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
            vb.customize ["modifyvm", :id, "--natdnshostresolver1", settings["natdnshostresolver"] ||= "on"]
            vb.customize ["modifyvm", :id, "--ostype", "Debian_64"]
            if settings.has_key?("gui") && settings["gui"]
                vb.gui = true
            end
        end

        # Configure The Public Key For SSH Access
        if settings.include? 'authorize'
            if File.exists? File.expand_path(settings["authorize"])
                config.vm.provision "shell" do |s|
                    s.inline = "echo $1 | grep -xq \"$1\" /home/vagrant/.ssh/authorized_keys || echo \"\n$1\" | tee -a /home/vagrant/.ssh/authorized_keys"
                    s.args = [File.read(File.expand_path(settings["authorize"]))]
                end
            end
        end

        # Copy The SSH Private Keys To The Box
        if settings.include? 'keys'
            if settings["keys"].to_s.length == 0
                puts "Check your Artyom.yaml file, you have no private key(s) specified."
                exit
            end
            settings["keys"].each do |key|
                if File.exists? File.expand_path(key)
                    config.vm.provision "shell" do |s|
                        s.privileged = false
                        s.inline = "echo \"$1\" > /home/vagrant/.ssh/$2 && chmod 600 /home/vagrant/.ssh/$2"
                        s.args = [File.read(File.expand_path(key)), key.split('/').last]
                    end
                else
                    puts "Check your Artyom.yaml file, the path to your private key does not exist."
                    exit
                end
            end
        end

        # Copy User Files Over to VM
        if settings.include? 'copy'
            settings["copy"].each do |file|
                config.vm.provision "file" do |f|
                    f.source = File.expand_path(file["from"])
                    f.destination = file["to"].chomp('/') + "/" + file["from"].split('/').last
                end
            end
        end

        # Register All Of The Configured Shared Folders
        if settings.include? 'folders'
            settings["folders"].each do |folder|
                if File.exists? File.expand_path(folder["map"])
                    mount_opts = []

                    if (folder["type"] == "nfs")
                        mount_opts = folder["mount_options"] ? folder["mount_options"] : ['actimeo=1', 'nolock']
                    elsif (folder["type"] == "smb")
                        mount_opts = folder["mount_options"] ? folder["mount_options"] : ['vers=3.02', 'mfsymlinks']
                    end

                    # For b/w compatibility keep separate 'mount_opts', but merge with options
                    options = (folder["options"] || {}).merge({ mount_options: mount_opts })

                    # Double-splat (**) operator only works with symbol keys, so convert
                    options.keys.each{|k| options[k.to_sym] = options.delete(k) }

                    config.vm.synced_folder folder["map"], folder["to"], type: folder["type"] ||= nil, **options

                    # Bindfs support to fix shared folder (NFS) permission issue on Mac
                    if Vagrant.has_plugin?("vagrant-bindfs")
                        config.bindfs.bind_folder folder["to"], folder["to"]
                    end
                else
                    config.vm.provision "shell" do |s|
                        s.inline = ">&2 echo \"Unable to mount one of your folders. Please check your folders in Artyom.yaml\""
                    end
                end
            end
        end

	end
	
		#copy proper config files
	Vagrant.configure("2") do |config|
		config.vm.provision "file", source: "config/.bashrc", destination: ".bashrc"
end

end