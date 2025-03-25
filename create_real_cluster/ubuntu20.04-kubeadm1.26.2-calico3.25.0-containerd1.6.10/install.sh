#!/bin/bash
## this script is to install K8s dependency
## before using: chmod 777 install.sh
## usage => ./install.sh

set -e -o pipefail # fail on error , debug all lines

sudo apt-get update
sudo apt-get upgrade -y

echo "Configuring k8s.conf..."
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system

sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

echo "Configuring containerd.conf..."
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

echo "Configuring 99-kubernetes-cri.conf..."
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system

echo "Installing containerd..."
sudo apt-get install containerd -y
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd

echo "Installing kubeadm..."
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo "Installing docker..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io  

cd /etc/docker
sudo touch /etc/docker/daemon.json

echo "Configuring docker daemon.json..."
cat <<EOF | sudo tee /etc/docker/daemon.json
{
"exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
cat /etc/docker/daemon.json
sudo systemctl restart docker
 
sudo usermod -aG docker $USER
sudo docker run hello-world

sudo kubeadm config images pull

echo "*******" 
echo "*** Now, run master.sh to install master node..."
echo "*** Usage => master.sh <MasterNodeIP>"
echo "*** If you are installing worker node, on master node: kubeadm token create --print-join-command"
echo "*** Copy and Paste the response into the each WORKER Node with SUDO command..."
echo "*******" 
