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

``` 
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
``` 

``` 
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
```

![image](https://user-images.githubusercontent.com/10358317/156151342-8e72ed0f-701e-41ff-88b9-e2bdaf9c51e5.png)

![image](https://user-images.githubusercontent.com/10358317/156151447-e4685bef-6437-46ba-9460-2cdd0f1dbe12.png)

#### 3. Install Containerd


#### 4. Install KubeAdm


### Reference
 
 - https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
 - https://github.com/aytitech/k8sfundamentals/tree/main/setup
 - https://multipass.run/
