#!/bin/bash

echo "$(date)"

echo " " 
echo " "
echo "Installing the yum-utils, device-mapper-persistent-data and lvm2 packages "
yum install -y yum-utils device-mapper-persistent-data lvm2 

if [ ! $? == 0 ]; then 
echo "" 
echo "$(date)" 
echo "The installation of the KS8 dependencies FAILED, install them manually."
echo "Exiting..."
exit -1
fi

{ # try
echo "" 
echo "$(date)" 
echo "Adding the docker repository..." 
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo 
} || { # catch
    echo "The docker repository couldn't be added to the Master Node"
    echo "Exiting..."
    exit -1
}


echo "Disabling firewall"
systemctl stop firewalld
systemctl disable firewalld

###Installing the KS8 repo
{ # try
echo "Installing the KS8 repo"
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF
} || { # catch
    echo "The KS8 repository couldn't be added to the Master Node"
    echo "Exiting..."
    exit -1
}


echo "" 
echo "$(date)" 
echo "Adding entries to the /etc/hosts"
NETWORK=$(cat /vagrant/Vagrantfile | grep "vm_net_ip[[:space:]]="  | sed 's/vm_net_ip[[:space:]]=[[:space:]]//g'  | sed 's/"//g') 
START_IP="10"
MASTER_NODE_IP=$(echo $NETWORK | sed 's/\r//g')$START_IP
NUMBER_OF_NODES=$(cat /vagrant/Vagrantfile | grep "N[[:space:]]="  | sed 's/N[[:space:]]=[[:space:]]//g' | sed 's/"//g' | sed 's/\r//g')
HOSTNAME_MN=$(cat /vagrant/Vagrantfile | grep "vm_hostname_mn[[:space:]]="  | sed 's/vm_hostname_mn[[:space:]]=[[:space:]]//g' | sed 's/"//g' | sed 's/\r//g')
HOSTNAME_WN=$(cat /vagrant/Vagrantfile | grep "vm_hostname_wn[[:space:]]="  | sed 's/vm_hostname_wn[[:space:]]=[[:space:]]//g' | sed 's/"//g' | sed 's/\r//g')

echo "$MASTER_NODE_IP     $HOSTNAME_MN" >> /etc/hosts

let START_INDEX=1
let END_INDEX=$NUMBER_OF_NODES

while [ $START_INDEX -le $END_INDEX ];
do
	let HOST=$START_INDEX+START_IP
	WNODE_IP=$(echo $NETWORK | sed 's/\r//g')$HOST
     echo "$WNODE_IP      $HOSTNAME_WN$START_INDEX" >> /etc/hosts
     ((START_INDEX++))
done


echo " "
echo "$(date)" 
echo "Installing the containerd, docker and docker-cli packages "

{ # try
 yum install -y \
  containerd.io3 \
  docker-ce \
  docker-ce-cli
} || { # catch
    echo "The installation of the KS8 dependencies FAILED, install them manually."
}


## Create /etc/docker directory.
mkdir /etc/docker

# Set up the Docker daemon
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF



mkdir -p /etc/systemd/system/docker.service.d

# Start Docker
systemctl daemon-reload
systemctl restart docker
systemctl enable docker

# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config


{ # try
echo "Installing Kubeadm, Kubelet and Kubectl"
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
echo "Enable Kubelet "
systemctl enable --now kubelet
} || { # catch
    echo "The installation of the Kubeadm, Kubelet and Kubectl FAILED"
    echo "Exiting"
    exit -1
}



{ # try
echo "Removing swap"
# does the swap file exist?
grep -q "swapfile" /etc/fstab

# if it does then remove it
if [ $? -eq 0 ]; then
	echo 'swapfile found. Removing swapfile.'
	sed -i '/swapfile/d' /etc/fstab
	echo "3" > /proc/sys/vm/drop_caches
	swapoff -a
	rm -f /swapfile
else
	echo 'No swapfile found. No changes made.'
fi

echo '--------------------------------------------'
echo 'Check whether the swap space removed.'
echo '--------------------------------------------'
swapon --show
} || { # catch
    echo "ERROR: The script couldn't remove the swap"
    echo "Exiting"
    exit -1
}



echo ""
echo ""
echo "$(date)"
echo "Creating the cluster"

echo "$(date)"
echo "Setting to 1 /proc/sys/net/bridge/bridge-nf-call-iptables"
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables


{ # try
NETWORK=$(cat /vagrant/Vagrantfile | grep "vm_net_ip[[:space:]]="  | sed 's/vm_net_ip[[:space:]]=[[:space:]]//g'  | sed 's/"//g') 
START_IP="10"
MASTER_NODE_IP=$(echo $NETWORK | sed 's/\r//g')
ssh-keygen -R $MASTER_NODE_IP$START_IP 
scp -i /vagrant/ssh-key -oStrictHostKeyChecking=no vagrant@$MASTER_NODE_IP$START_IP:/vagrant/ks8-join.sh /vagrant/ks8-join.sh
chmod u+x /vagrant/ks8-join.sh
} || { # catch
    echo "ERROR: failed script while gathering join script from  (Master Node)"
    echo "Copy the script /vagrant/ks8-join.sh and runt it on every Worker Node"
}


{ # try
echo ""
echo ""
echo "$(date)"
echo "Joining worker node to the KS8 cluster"
/vagrant/ks8-join.sh
} || { # catch
echo ""
echo "$(date)"
echo "ERROR: The worker node couldn't joint to the cluster."
}

echo ""
echo ""
echo "$(date)"
echo "The Worker Node successfully created."

