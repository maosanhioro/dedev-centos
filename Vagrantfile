# -*- mode: ruby -*-
# vi: set ft=ruby :
#
Dotenv.load

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  config.vm.define "default" do |default|
    default.vm.box = "#{ENV['DEFAULT_BOX']}"
    default.vm.network "private_network", ip: "#{ENV['DEFAULT_PRIVATE_IP']}"
    # default.vm.network "private_network", ip: "#{ENV['DEFAULT_PRIVATE_IP']}", virtualbox__intnet: "#{ENV['DEFAULT_PRIVATE_INTNET']}"
    # default.vm.network :public_network, bridge: "#{ENV['DEFAULT_PUBLIC_BRIDGE']}", ip: "#{ENV['DEFAULT_PUBLIC_IP']}", netmask: "#{ENV['DEFAULT_PUBLIC_NETMASK']}"
    # default.vm.network "forwarded_port", guest: 80, host: 8080
    default.vm.network "forwarded_port", guest: 143, host: 143
    default.vm.network "forwarded_port", guest: 25, host: 25
    default.vm.synced_folder "#{ENV['DEFAULT_SYNCED_HOST']}", "#{ENV['DEFAULT_SYNCED_GUEST']}",
        owner: "#{ENV['DEFAULT_SYNCED_OWNER']}",
        group: "#{ENV['DEFAULT_SYNCED_GROUP']}",
        mount_options: ["#{ENV['DEFAULT_SYNCED_OPTIONS']}"]
  end

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL
end
