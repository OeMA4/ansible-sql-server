# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

	config.vm.define "control", primary: true do |control|
		control.vm.box = "ubuntu/trusty64"

		control.vm.network "private_network", ip: "192.168.50.3", virtualbox__intnet: "mynetwork"

		control.vm.provision "shell", path: "provisioning/control/install-python.sh"
		control.vm.provision "shell", path: "provisioning/control/install-ansible.sh"
		control.vm.provision "shell", inline: "sudo cp /vagrant/provisioning/control/hosts /etc/ansible/hosts"
	end

	config.vm.define "win" do |win|
		win.vm.network "private_network", ip: "192.168.50.4", virtualbox__intnet: "mynetwork"
		win.vm.box = "opentable/win-2012r2-standard-amd64-nocm"

		# Admin user name and password
		win.vm.communicator = "winrm"
		win.winrm.username = "vagrant"
		win.winrm.password = "vagrant"

		win.vm.guest = :windows
		win.windows.halt_timeout = 15

		win.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true
		win.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", auto_correct: true
		win.vm.provider "virtualbox" do |vb|
			# Display the VirtualBox GUI when booting the machine
			vb.gui = true

			# Customize the amount of memory and cpus on the VM:
			vb.memory = "2048"
			vb.cpus = "2"
		end

		win.vm.provision "shell", path: "provisioning/win/enablePing.ps1"
    
	end
end
