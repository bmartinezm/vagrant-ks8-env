# -*- mode: ruby -*-
#
# Vagrantfile - Byron Martinez - bdmartinezm22@gmail.com
#


################
## PARAMETERS ##
################
#Centos Release

###################
##### GENERAL #####

#Centos Release
centos_release = 7
# Centos GUI - GUI installation
vm_gui = false
# Box Image and Version
vm_box = "centos/#{centos_release}"
## Memory and PCI
vm_size = {"cpus" => 2, "memory" => 2048}
#Working directory
vagrant_assets = File.dirname(__FILE__) + "/vagrant"


#  Minimum VM customization
vm_name_mn = "centos-ks8-mnode"
vm_hostname_mn = "ks8-masternode"
vm_name_wn = "centos-ks8-wnode"
vm_hostname_wn = "ks8-workernode"

#Number of nodes worker nodes, TOTAL VMs = N+1
N = 2

# Network configuration 
vm_net_mask = "255.255.255.0"
vm_net_ip = "192.168.100."

###################
## CONFIGURATION ##
###################

Vagrant.configure(2) do |config|
	#config.vagrant.plugins = ["vagrant-vbguest"]

    #Enable the default /vagrant share
    config.vm.synced_folder "./vagrant", "/vagrant", type: "rsync"

    config.vm.define "mn" do |mn|

	    mn.vm.box = vm_box
        #config.vm.box_version = vm_box_version.nil? ? vm_box_version : ">= 0"
        mn.vm.hostname = vm_hostname_mn

   	    mn.vm.network "private_network", ip: vm_net_ip.delete_suffix('X')+"10", 
   	    netmask: vm_net_mask

        #config.vm.provision "shell", run: "always", inline: "ip addr add 192.168.15.200 dev eth1"

        # Make the local user's SSH key reachable by the main provisioning script...
        mn.vm.provision "file", source: File.dirname(__FILE__) +"/ssh-key.pub", destination: "~/.ssh/authorized_keys"


        # Perform base-system customizations and install project-specific dependencies...
        mn.vm.provision "shell", path: "#{vagrant_assets}/provisionMN.sh",
                                 privileged: true  # ...run as the "root" user.

        mn.ssh.forward_agent = true
        mn.ssh.keep_alive = true

        mn.vm.provider "virtualbox" do |vm, override|
            vm.name = vm_name_mn
            vm.gui = vm_gui

            vm.memory = vm_size["memory"]
            vm.cpus = vm_size["cpus"]
            vm.default_nic_type = "virtio"
        end
    end

    (1..N).each do |i|
    config.vm.define "wn#{i}" do |wn|

        wn.vm.box = vm_box
        #config.vm.box_version = vm_box_version.nil? ? vm_box_version : ">= 0"
        wn.vm.hostname = vm_hostname_wn+"#{i}"

        wn.vm.network "private_network", ip: vm_net_ip+"#{i+10}", 
        netmask: vm_net_mask

        # Make the local user's SSH key reachable by the main provisioning script...
        wn.vm.provision "file", source: File.dirname(__FILE__) +"/ssh-key.pub", destination: "~/.ssh/authorized_keys"


        # Perform base-system customizations and install project-specific dependencies...
        wn.vm.provision "shell", path: "#{vagrant_assets}/provisionWN.sh"

        wn.ssh.forward_agent = true
        wn.ssh.keep_alive = true

        wn.vm.provider "virtualbox" do |vm, override|
            vm.name = vm_name_wn+"#{i}"
            vm.gui = vm_gui

            vm.memory = vm_size["memory"]
            vm.cpus = vm_size["cpus"]
            vm.default_nic_type = "virtio"
        end
    end
    end  





end