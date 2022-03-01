## K8s Kubeadm Cluster Setup 

This scenario shows how to create K8s cluster on virtual PC (multipass, kubeadm, containerd) 



### Steps

#### 1. Multipass Installation - Creating VM

- "Multipass is a mini-cloud on your workstation using native hypervisors of all the supported plaforms (Windows, macOS and Linux)"
- Fast to install and to use.
- **Link:** https://multipass.run/

``` 
# creating master, worker1
# -c => cpu, -m => memory, -d => disk space
multipass launch --name master -c 2 -m 2G -d 10G   
multipass launch --name worker1 -c 2 -m 2G -d 10G
``` 

![image](https://user-images.githubusercontent.com/10358317/156150337-2f4b3ac9-df42-4567-a848-6869362a3001.png)

``` 
# get shell on master 
multipass shell master
# get shell on worker1
multipass shell worker1
``` 

![image](https://user-images.githubusercontent.com/10358317/156150843-db217ba0-8fff-4a77-9f3d-09f9f71314df.png)

#### 2. IP-Tables Bridged Traffic Configuration

- Run on both nodes: 
``` 
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
``` 

- Run on both nodes: 
``` 
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
```

![image](https://user-images.githubusercontent.com/10358317/156151342-8e72ed0f-701e-41ff-88b9-e2bdaf9c51e5.png)

![image](https://user-images.githubusercontent.com/10358317/156151447-e4685bef-6437-46ba-9460-2cdd0f1dbe12.png)

- Run on both nodes: 
``` 
sudo sysctl --system
```

![image](https://user-images.githubusercontent.com/10358317/156158062-01f3edc8-df31-4a83-9dcc-d173c3cc921b.png)

#### 3. Install Containerd
- Run on both nodes: 
``` 
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
```

- Run on both nodes: 
``` 
sudo modprobe overlay
sudo modprobe br_netfilter
```

- Run on both nodes: 
``` 
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
```

- Run on both nodes: 
``` 
sudo sysctl --system
```

![image](https://user-images.githubusercontent.com/10358317/156159159-1cb24ead-4cdb-4912-8382-c12a23d9271c.png)

![image](https://user-images.githubusercontent.com/10358317/156159208-dfc96be6-62b6-4b6d-8e12-1a48541e89cb.png)

- Run on both nodes: 
``` 
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install containerd -y
sudo mkdir -p /etc/containerd
sudo su -
containerd config default | tee /etc/containerd/config.toml
exit
sudo systemctl restart containerd
```

![image](https://user-images.githubusercontent.com/10358317/156160352-035d8bf2-79c5-43c0-a6d6-74b6211993a7.png)

![image](https://user-images.githubusercontent.com/10358317/156160304-2cedfc2f-a436-44a3-8d60-a3af2bf3436c.png)

![image](https://user-images.githubusercontent.com/10358317/156160237-582b6fb3-6289-4e8e-a3f9-f4f9c5a15b91.png)

![image](https://user-images.githubusercontent.com/10358317/156160159-10df522b-f726-4a5a-93e6-19b4bb85f10a.png)

![image](https://user-images.githubusercontent.com/10358317/156160102-ce0437a8-1054-46ab-b79d-47527d4462e3.png)

#### 4. Install KubeAdm
- Run on both nodes: 
``` 
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

![image](https://user-images.githubusercontent.com/10358317/156160934-11c45c68-a5e5-46fd-bde7-96301277b906.png)

![image](https://user-images.githubusercontent.com/10358317/156160979-f4f79703-9e60-4b59-b8fe-5fbd14969622.png)

![image](https://user-images.githubusercontent.com/10358317/156161071-59d5f19a-ca62-48a2-97db-73de53e2d29d.png)

![image](https://user-images.githubusercontent.com/10358317/156161142-e7ba1322-9cf8-4edf-9018-082fa5b2f76a.png)


#### 5. Install Kubernetes Cluster

- Run on both nodes: 
``` 
sudo kubeadm config images pull
```

![image](https://user-images.githubusercontent.com/10358317/156161542-7da94e9a-f124-4e05-896d-0c9fb2208729.png)

- From worker1, ping the master to learn IP of master.
``` 
ping master
```
![image](https://user-images.githubusercontent.com/10358317/156161683-63d2d56a-e5b1-4826-9665-e872a333d520.png)

- Run on master: 
``` 
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=<ip> --control-plane-endpoint=<ip>
# sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=172.31.45.74 --control-plane-endpoint=172.31.45.74
```

![image](https://user-images.githubusercontent.com/10358317/156162236-15fa0c78-dccc-4bfb-8c0b-179b86a8ed31.png)

- After kubeadm init command, master node responses back the followings:
 
![image](https://user-images.githubusercontent.com/10358317/156163029-e31ea507-9912-4377-a93d-93863c37039a.png)

- On the master node run:

```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

![image](https://user-images.githubusercontent.com/10358317/156163241-66fed5a3-593e-4efd-8f12-2d024ef7554c.png)

- On the worker node, run to join cluster (tokens are different in your case, please look at the kubeadm init respond):

```
sudo kubeadm join 172.31.45.74:6443 --token w7nntd.7t6qg4cd418wzkup \
        --discovery-token-ca-cert-hash sha256:1f03886e5a28fb9716e01794b4a01144f362bf431220f15ca98bed2f5a44e91b
```

- If it is required to create another master node, copy the control plane line (tokens are different in your case, please look at the kubeadm init respond):

```
sudo kubeadm join 172.31.45.74:6443 --token w7nntd.7t6qg4cd418wzkup \
        --discovery-token-ca-cert-hash sha256:1f03886e5a28fb9716e01794b4a01144f362bf431220f15ca98bed2f5a44e91b \
        --control-plane
```

![image](https://user-images.githubusercontent.com/10358317/156163626-ae2baf3f-43e8-4747-8fdc-80738603adbe.png)

- On Master node: 

![image](https://user-images.githubusercontent.com/10358317/156163717-c9c771c1-a850-4706-80dd-7fa85b890c2a.png)


#### 6. Install Kubernetes Network Infrastructure

- Calico is used for network plugin on K8s. Others (flannel, weave) could be also used. 
- Run only on Master: 

```
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml
```

![image](https://user-images.githubusercontent.com/10358317/156164127-d21ff5be-35d6-4ec6-a507-2ae0155031ac.png)

![image](https://user-images.githubusercontent.com/10358317/156164265-1d13bab5-6c55-4421-b7a8-e835d5d0ebfc.png)

- After running network implementation, nodes are now ready. Only Master node is used to get information about the cluster.

![image](https://user-images.githubusercontent.com/10358317/156164572-5525bda3-6ff5-49a2-9a2f-392a804b4da2.png)


![image](https://user-images.githubusercontent.com/10358317/156165250-f1647540-467a-445d-8381-dd320922a70d.png)

### Reference
 
 - https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
 - https://github.com/aytitech/k8sfundamentals/tree/main/setup
 - https://multipass.run/
