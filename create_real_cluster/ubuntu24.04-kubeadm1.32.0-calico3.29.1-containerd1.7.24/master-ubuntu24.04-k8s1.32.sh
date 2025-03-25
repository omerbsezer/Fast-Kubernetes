#!/bin/bash
## this script is to create K8s Master, 
## usage => master.sh <MasterNodeIP>

set -e -o pipefail # fail on error , debug all lines

echo "Initiating K8s Cluster..."
sudo kubeadm init --pod-network-cidr=172.24.0.0/16 --apiserver-advertise-address=$1 --control-plane-endpoint=$1
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "Install calico..."
curl https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/calico.yaml > calico.yaml
kubectl apply -f ./calico.yaml

echo "Install calicoctl..."
sudo curl -o /usr/local/bin/calicoctl -O -L "https://github.com/projectcalico/calico/releases/download/v3.29.1/calicoctl-linux-amd64"
sudo chmod +x /usr/local/bin/calicoctl

echo "Disable IPinIP..."  
echo "Waiting 40sec..."
sleep 40
calicoctl get ipPool 'default-ipv4-ippool' -o yaml
calicoctl get ipPool 'default-ipv4-ippool' -o yaml > ippool.yaml
sed -i 's/Always/Never/g' ippool.yaml 
calicoctl apply -f ippool.yaml

echo "Configure felixconfig..."   
echo "Waiting 5sec..."
sleep 5 
kubectl get felixconfigurations.crd.projectcalico.org default  -o yaml -n kube-system > felixconfig.yaml
sed -i 's/true/false/g' felixconfig.yaml
kubectl apply -f felixconfig.yaml     

calicoctl ipam configure --strictaffinity=true
sleep 2 
echo "" 
echo "*******" 
echo "*** Please REBOOT/RESTART the PC now..."
echo "*** After restart run on this Master node: kubeadm token create --print-join-command"
echo "*** After restart if you encounter error (not to reach cluster, or API), please run closing swap commands again:"
echo "*** sudo swapoff -a"
echo "*** sudo sed -i '/ swap / s/^/#/' /etc/fstab"
echo "*** Copy and Paste the response into the each WORKER Node with SUDO command..."
kubeadm token create --print-join-command 
echo ""
echo "*** K8s Master Node is now up and the cluster is created..."
echo "*******" 
kubectl cluster-info
kubectl get nodes -o wide
#sudo reboot

# https://docs.tigera.io/calico/latest/getting-started/kubernetes/windows-calico/kubeconfig
echo "*******" 
echo "*** Calico-Node secret will be created for Windows Calico..."
echo "*******" 
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: calico-node
  namespace: kube-system
  annotations:
    kubernetes.io/service-account.name: calico-node
type: kubernetes.io/service-account-token
EOF
