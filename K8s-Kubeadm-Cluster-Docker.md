## LAB: K8s Cluster Setup with Kubeadm and Docker

- This scenario shows how to create K8s cluster on virtual PC (multipass, kubeadm, docker) 

### Table of Contents
- [Creating Cluster With Kubeadm, Docker](#creating)


## 1. Creating Cluster With Kubeadm, Docker <a name="creating"></a>

#### 1.1 Multipass Installation - Creating VM

- "Multipass is a mini-cloud on your workstation using native hypervisors of all the supported plaforms (Windows, macOS and Linux)"
- Fast to install and to use.
- **Link:** https://multipass.run/

``` 
# creating VM
multipass launch --name k8s-controller --cpus 2 --mem 2048M --disk 10G 
multipass launch --name k8s-node1 --cpus 2 --mem 1024M --disk 7G
multipass launch --name k8s-node2 --cpus 2 --mem 1024M --disk 7G
``` 

![image](https://user-images.githubusercontent.com/10358317/157879969-a049706d-e8b8-4096-97bb-dca4e9a9b87e.png)

``` 
# get shells on different terminals
multipass shell k8s-controller
multipass shell k8s-node1
multipass shell k8s-node2
multipass list
``` 

![image](https://user-images.githubusercontent.com/10358317/157880347-dead1390-692c-4725-8e37-89121a346d7e.png)

#### 1.2 Install Docker

- Run for all 3 nodes on different terminals:

``` 
sudo apt-get update
sudo apt-get install docker.io -y                # install Docker
sudo systemctl start docker                      # start and enable the Docker service
sudo systemctl enable docker
sudo usermod -aG docker $USER                    # add the current user to the docker group
newgrp docker                                    # make the system aware of the new group addition
```

#### 1.3 Install Kubeadm

- Run for all 3 nodes on different terminals:

```
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add              # add the repository key and the repository
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt-get install kubeadm kubelet kubectl -y                                               # install all of the necessary Kubernetes tools
```

- Run on new terminal:

```
multipass list
```

![image](https://user-images.githubusercontent.com/10358317/157883859-55497a48-3774-4f6c-bf8c-29cc8d591a82.png)

- Run on controller, add IPs of PCs:

```
sudo nano /etc/hosts
```

![image](https://user-images.githubusercontent.com/10358317/157883663-af21c3fb-bc19-4b37-9da1-112b1c974c84.png)

- Run for all 3 nodes on different terminals:

```
sudo swapoff -a         # turn off swap
```

- Create this file "daemon.json" in the directory "/etc/docker", docker change cgroup driver to systemd, run on 3 different machines:

```
cd /etc/docker
sudo touch daemon.json
sudo nano daemon.json
# copy and paste it on daemon.json
{
"exec-opts": ["native.cgroupdriver=systemd"]
}
sudo systemctl restart docker
```

- Run on the controller:

```
sudo kubeadm init --pod-network-cidr=192.168.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo kubectl get nodes
```

![image](https://user-images.githubusercontent.com/10358317/157886788-4a136836-924b-4938-bfdc-0a07e9c16163.png)

![image](https://user-images.githubusercontent.com/10358317/157887715-27661178-2a0b-4314-ae84-30598cfd5e68.png)

- Run on the nodes (node1, node2):

```
sudo kubeadm join 172.29.108.209:6443 --token ug13ec.cvi0jwi9xyf82b6f \
        --discovery-token-ca-cert-hash sha256:12d59142ccd0148d3f12a673b5c47a2f549cce6b7647963882acd90f9b0fbd28
```      

- Run "kubectl get nodes" on the controller, after deploying pod network, nodes will be ready.

![image](https://user-images.githubusercontent.com/10358317/157888135-5ad0e931-8a2d-4389-83c2-ec1d8d909c25.png)

- Run on Controller to deploy a pod network:
  - Flannel:
    ```
    sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
    ```
  - Calico:
    ```
    kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
    kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml
    ```   
    
![image](https://user-images.githubusercontent.com/10358317/157889081-d9ee73ed-ebb3-4386-bbef-03113b199ef3.png)
    
- After testing more (restarting master, etc.), Containerd is more stable than Dockerd run time => [KubeAdm-Containerd Setup](https://github.com/omerbsezer/Fast-Kubernetes/blob/main/K8s-Kubeadm-Cluster-Setup.md)

##  2. IP address changes in Kubernetes Master Node <a name="master_ip_changed"></a>
- After restarting Master Node, it could be possible that the IP of master node is updated. Your K8s cluster API's IP is still old IP of the node. So you should configure the K8s cluster with new IP.

- You cannot reach API when using kubectl commands:

![image](https://user-images.githubusercontent.com/10358317/156803085-e99717a4-da62-453f-97bb-fb86c09edaca.png)

- If you installed the docker for the docker registry, you can remove the exited containers:

```
sudo docker rm $(sudo docker ps -a -f status=exited -q)
```

#### On Master Node: 

```
sudo kubeadm reset
sudo kubeadm init --pod-network-cidr=192.168.0.0/16
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
```

![image](https://user-images.githubusercontent.com/10358317/156803554-21741c6e-74bb-4902-9130-bc835b91e76f.png)

![image](https://user-images.githubusercontent.com/10358317/156803646-f943be3e-158d-4f3d-9f26-fe06a8436439.png)

- It shows which command should be used to join cluster:

```
sudo kubeadm join 172.31.40.125:6443 --token 07vo3z.q2n2qz6bd07ipdnf \
        --discovery-token-ca-cert-hash sha256:46c7dcb092ca091e71ab39bd542e73b90b3f7bdf0c486202b857a678cd9879ba
```
![image](https://user-images.githubusercontent.com/10358317/156803877-89ac5a24-6dd6-40d0-8568-3c6b70acbd89.png)

![image](https://user-images.githubusercontent.com/10358317/156804162-cc8c3f2b-5d3f-407a-9ced-31322b6bb39b.png)


- Network Configuratin with new IP:

```
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml
```

![image](https://user-images.githubusercontent.com/10358317/156804328-c8068ef9-5a7d-4230-a4e9-56aa6a111da9.png)

### Reference
- https://thenewstack.io/deploy-a-kubernetes-desktop-cluster-with-ubuntu-multipass/
