## LAB: K8s Cluster Setup with Kubeadm and Containerd 

This scenario shows how to create K8s cluster on virtual PC (multipass, kubeadm, containerd) 


### Table of Contents
- [Creating Cluster With Kubeadm, Containerd](#creating)
- [Joining New K8s Worker Node to Existing Cluster](#joining)
- [IP address changes in Kubernetes Master Node](#master_ip_changed)
- [Removing the Worker Node from Cluster](#removing)
- [Installing Docker on Existing Cluster & Starting of Running Local Registry for Storing Local Image](#docker_registry)
- [After Installing Docker on Existing Cluster=> When restarting Master, kubeadm init (kubelet) error](#kubelet_error)
- [Pulling Image from Docker Local Registry and Configure Containerd](#local_image)

## 1. Creating Cluster With Kubeadm, Containerd <a name="creating"></a>

#### 1.1 Multipass Installation - Creating VM

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

#### 1.2 IP-Tables Bridged Traffic Configuration

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

##### This part is optional:

- Close swaps on the OS. Because it is required if you run on directly OS (on-premise)(instead of running on VM)
```
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
```

- If you install your cluster behind the proxy, you should define http_proxy, https_proxy, ftp_proxy and no_proxy environment variables on /etc/environment.
- You should add ::6443 and Master Node IP.
```
export no_proxy="192.168.*.*, ::6443, <yourMasterIP>:6443, 172.24.*.*, 172.25.*.*, 10.*.*.*, localhost, 127.0.0.1"
```

#### 1.3 Install Containerd
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

#### 1.4 Install KubeAdm
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


#### 1.5 Install Kubernetes Cluster

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


#### 1.6 Install Kubernetes Network Infrastructure

- Calico is used for network plugin on K8s. Others (flannel, weave) could be also used. 
- Run only on Master: 
  - Calico:
  ```
  kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
  kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml
  ```
  - Flannel:
  ```
  kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
  ```

**NOTE:** If you create Windows node to join K8s Cluster as worker node, it is required to configure flannel for Linux Control-Plane. Please have a look here for more information: https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/adding-windows-nodes/

#### 1.6.1 Configuring Flannel.yml for Windows Worker Node (If Windows Worker Node will be added into the K8s Cluster)

- On the master, run:
```
wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```
- Modify kube-flannel.yml by adding "VNI": 4096, "Port": 4789:
```
net-conf.json: |
    {
      "Network": "10.244.0.0/16",
      "Backend": {
        "Type": "vxlan",
        "VNI": 4096,
        "Port": 4789
      }
    }
 ``` 
**NOTE:** The VNI must be set to 4096 and port 4789 for Flannel on Linux to interoperate with Flannel on Windows. See the [VXLAN documentation](https://github.com/flannel-io/flannel/blob/master/Documentation/backends.md#vxlan). for an explanation of these fields.

- Run on master: 
```
kubectl apply -f kube-flannel.yml
kubectl get pods -n kube-system
```

![image](https://user-images.githubusercontent.com/10358317/156164127-d21ff5be-35d6-4ec6-a507-2ae0155031ac.png)

![image](https://user-images.githubusercontent.com/10358317/156164265-1d13bab5-6c55-4421-b7a8-e835d5d0ebfc.png)

- After running network implementation, nodes are now ready. Only Master node is used to get information about the cluster.

![image](https://user-images.githubusercontent.com/10358317/156164572-5525bda3-6ff5-49a2-9a2f-392a804b4da2.png)


![image](https://user-images.githubusercontent.com/10358317/156165250-f1647540-467a-445d-8381-dd320922a70d.png)


## 2. Joining New K8s Worker Node to Existing Cluster <a name="joining"></a>

- If we lose the token and token CA cert dash and API server address, wé need to learn them to join a new node into the cluster.
- We are adding new node to existing cluster above. We need to get join token, discovery token CA cert hash, API server advertise address. After getting info, we'll create join command for each nodes. 
- Run on Master to get certificate and token information:

```
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
kubeadm token list
kubectl cluster-info
```

![image](https://user-images.githubusercontent.com/10358317/156349584-9fe2f41e-4368-43ef-9674-c78512230938.png)

- In this example, token TTL has 3 hours left (normally, token expires in 24 hours). So we don't need to create new token.  
- If the token is expired, generate a new one with the command:

```
sudo kubeadm token create
kubeadm token list
```

- Create join command for worker nodes:

```
kubeadm join \
  <control-plane-host>:<control-plane-port> \
  --token <token> \
  --discovery-token-ca-cert-hash sha256:<hash>
```

- In our case, we run the following command on both workers (worker2, worker3):

```
sudo kubeadm join 172.31.32.27:6443 --token 39g7sx.v589tv38nxhus74k --discovery-token-ca-cert-hash sha256:1db5d45337803e35e438cdcdd9ff77449fef3272381ee43784626f19c873d356
```

![image](https://user-images.githubusercontent.com/10358317/156350767-b14335d0-1d63-4ab1-a939-6eb47fadac9d.png)

![image](https://user-images.githubusercontent.com/10358317/156350852-d1df7b93-13aa-462d-8cce-51f3b9b6e553.png)

- Then, we get nodes ready, run on master:

```
kubectl get nodes
```

![image](https://user-images.githubusercontent.com/10358317/156351061-7c1af34b-63cd-49dc-a8a1-74679c765516.png)

- Ref: https://computingforgeeks.com/join-new-kubernetes-worker-node-to-existing-cluster/

##  3. IP address changes in Kubernetes Master Node <a name="master_ip_changed"></a>
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

- After kubeadm reset, if there is an error that shows the some of the ports still using, please use following command to kill process, then run kubeadm init:

```
sudo netstat -lnp | grep <PortNumber>
sudo kill <PID>
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


- Network Configuration with new IP:

```
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml
```

![image](https://user-images.githubusercontent.com/10358317/156804328-c8068ef9-5a7d-4230-a4e9-56aa6a111da9.png)

#### On Worker Nodes: 

```
sudo kubeadm reset
sudo kubeadm join 172.31.40.125:6443 --token 07vo3z.q2n2qz6bd07ipdnf \
        --discovery-token-ca-cert-hash sha256:46c7dcb092ca091e71ab39bd542e73b90b3f7bdf0c486202b857a678cd9879ba
```

![image](https://user-images.githubusercontent.com/10358317/156805582-bb66e20b-5b81-49b5-995f-96023c943f3b.png)

![image](https://user-images.githubusercontent.com/10358317/156805882-e2e2144d-f3dc-4b87-81a8-a9f1c4827a5b.png)

On Master Node:

- Worker1 is now joined the cluster.

```
kubectl get nodes
```

![image](https://user-images.githubusercontent.com/10358317/156805995-49e8a6f5-5293-46b8-9684-59f18d6f5ab2.png)

##  4. Removing the Worker Node from Cluster <a name="removing"></a>

- Run commands on Master Node to remove specific worker node:

```
kubectl get nodes
kubectl drain worker2
kubectl delete node worker2
```

![image](https://user-images.githubusercontent.com/10358317/157018826-8cbae29e-b5e4-4a6d-bf8e-72d3006ce33e.png)

Run on the specific deleted node (worker2)

```
sudo kubeadm reset
```

![image](https://user-images.githubusercontent.com/10358317/157018963-422b1b72-667c-4375-b9ee-8035823396d7.png)

##  5. Installing Docker on Existing Cluster & Starting of Running Local Registry for Storing Local Image <a name="docker_registry"></a>

#### 5.1 Installing Docker

- Run commands on Master Node to install docker on Master node:

```
 sudo apt-get update
 sudo apt-get install ca-certificates curl gnupg lsb-release
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
 echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo docker run hello-world
```

**Goto for more information:** https://docs.docker.com/engine/install/ubuntu/

![image](https://user-images.githubusercontent.com/10358317/157026833-fcd829fd-a5dd-4701-b71a-89327445483d.png)

![image](https://user-images.githubusercontent.com/10358317/157027173-8be0d193-4ac9-4a82-ac3b-33fbd68ba42d.png)

![image](https://user-images.githubusercontent.com/10358317/157027863-787bf3cb-3e0c-4888-8de6-80e2145a383c.png)

![image](https://user-images.githubusercontent.com/10358317/157028189-2585365e-51e5-4dfa-9d60-5ac9d73c258a.png)

![image](https://user-images.githubusercontent.com/10358317/157028470-e09a783d-1413-4d87-bbaf-463741871a68.png)

```
sudo docker image ls
kubectl get nodes
```

![image](https://user-images.githubusercontent.com/10358317/157028638-6931e150-65b0-4361-8d37-ab2f0c9a8461.png)

- Copy and run on all nodes to change Docker's Cgroup:

```
cd /etc/docker
sudo touch daemon.json
sudo nano daemon.json
# in the file, paste:
{
"exec-opts": ["native.cgroupdriver=systemd"]
}
sudo systemctl restart docker
```

If your cluster is behind the proxy, configure PROXY settings of Docker (ref: add docker proxy: https://docs.docker.com/config/daemon/systemd/). Copy and run on all nodes:
```
sudo mkdir -p /etc/systemd/system/docker.service.d
cd /etc/systemd/system/docker.service.d/
sudo touch http-proxy.conf
sudo nano http-proxy.conf
# copy and paste in the file:
[Service]
Environment="HTTP_PROXY=http://<ProxyIP>:3128"
Environment="HTTPS_PROXY=http://<ProxyIP>:3128"
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl show --property=Environment docker
sudo docker run hello-world
```

#### 5.2 Running Docker Registry

Run on Master to pull registry:

```
sudo docker image pull registry
```

- Run container using 'Registry' image: (-p: port binding [hostPort]:[containerPort], -d: detach mode (running background), -e: change environment variables status)
```
sudo docker container run -d -p 5000:5000 --restart always --name localregistry -e REGISTRY_STORAGE_DELETE_ENABLED=true registry
```

- Run registry container with binding mount (-v) and without getting error 500 (REGISTRY_VALIDATION_DISABLED=true):
```
sudo docker run -d -p 5000:5000 --restart=always --name registry -v /home/docker_registry:/var/lib/registry -e REGISTRY_STORAGE_DELETE_ENABLED=true -e REGISTRY_VALIDATION_DISABLED=true -e REGISTRY_HTTP_ADDR=0.0.0.0:5000 registry
```

![image](https://user-images.githubusercontent.com/10358317/157030622-69ab3019-6cff-43ee-8a3d-fe277d7632b5.png)

![image](https://user-images.githubusercontent.com/10358317/157030738-be8eb8c3-0f87-4d39-969b-bd94cb8b0f9f.png)

- Open with browser or run curl command:
```
curl http://127.0.0.1:5000/v2/_catalog
```
![image](https://user-images.githubusercontent.com/10358317/157031139-edf0162d-d753-4d75-a39a-127583bb47fe.png)


##  6. After Installing Docker on Existing Cluster=> When restarting Master, kubeadm init (kubelet) error  <a name="kubelet_error"></a>

- After Installing Docker on Existing Cluster:  When it needs to restart Master, both containerd and docker run on the master node and when running "Kubeadm init", you will encounter that kubelet does not work properly. 

```
[kubelet-check] It seems like the kubelet isn't running or healthy.
[kubelet-check] The HTTP call equal to 'curl -sSL http://localhost:10248/healthz' failed with error: Get "http://localhost:10248/healthz": dial tcp [::1]:10248: connect: connection refused.
```

![image](https://user-images.githubusercontent.com/10358317/157424299-ff6d20c2-65e5-4a70-abf3-43579a04f5e1.png)

- It can be solved with creating  this file "daemon.json" in the directory "/etc/docker" and add the following:

```
{
"exec-opts": ["native.cgroupdriver=systemd"]
}
```

![image](https://user-images.githubusercontent.com/10358317/157424989-671ee3e8-b33c-4d7e-b0d6-ee1fd5685f70.png)

![image](https://user-images.githubusercontent.com/10358317/157425768-a8446317-3477-4719-9bf8-0014ef134335.png)

- Restart your docker service: systemctl restart docker

```
systemctl restart docker
```

![image](https://user-images.githubusercontent.com/10358317/157425383-4d82e707-1a98-4dcd-b59e-1239121b5850.png)


- Reset kubeadm initializations and run normal: 

```
sudo kubeadm reset
sudo kubeadm init --pod-network-cidr=192.168.0.0/16
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml
kubectl get nodes
sudo docker image ls
```

![image](https://user-images.githubusercontent.com/10358317/157425595-a05f8ec6-ef76-4e64-a525-3d20e7b6ed3d.png)

##  7. Pulling Image from Docker Local Registry and Configure Containerd  <a name="local_image"></a>

- In this scenario, docker local registry already runs on the Master node (see [Section 5](#docker_registry))
- First add insecure-registry into /etc/docker/daemon.js on the **ALL Nodes**:

```
sudo nano /etc/docker/daemon.json
# copy insecure-registries and paste it
{
"exec-opts": ["native.cgroupdriver=systemd"],
"insecure-registries":["192.168.219.64:5000"]
}
sudo systemctl restart docker.service
```

![image](https://user-images.githubusercontent.com/10358317/157729358-cf496d8f-24f9-4bff-b263-7a196efb035c.png)

- Pull image from DockerHub, label with new tag and push the local registry on master node:

```
sudo docker image pull nginx:latest
ifconfig                           # to get master IP
sudo docker image tag nginx:latest 192.168.219.64:5000/nginx:latest
sudo docker image push 192.168.219.64:5000/nginx:latest
curl http://192.168.219.64:5000/v2/_catalog
sudo docker image pull 192.168.219.64:5000/nginx:latest
```

- Create docker config and get authentication username and pass in base64 coded:

```
sudo docker login       # this creates /root/.docker/config
sudo cat /root/.docker/config.json | base64 -w0   # copy the base64 encoded key
```

- Create my-secret.yaml and paste the base64 encoded key: 

```
apiVersion: v1
kind: Secret
metadata:
  name: registrypullsecret
data:
  .dockerconfigjson: <base-64-encoded-json-here>
type: kubernetes.io/dockerconfigjson
```

- Create secret. Kubelet uses this secret to pull image:

```
kubectl create -f my-secret.yaml && kubectl get secrets
```

- Create nginx_pod.yaml. Image name shows where the image is pulled from. In addition, "imagePullSecrets" should be defined, which secret should be used for pulling image for local docker registry.  
 
```
apiVersion: v1
kind: Pod
metadata:
  name: my-private-pod
spec:
  containers:
    - name: private
      image: 192.168.219.64:5000/nginx:latest
  imagePullSecrets:
    - name: registrypullsecret
```

![image](https://user-images.githubusercontent.com/10358317/157726621-858e57b1-4e4c-48dc-9900-c5fe3024d5ae.png)

- On the **ALL Nodes**, registry IP and the port should be defined:

```
sudo nano /etc/containerd/config.toml   # if containerd is using as runtime. If this was Docker, on /etc/docker/daemon.js add insecure-registries like master 
# copy and paste (our IP: 192.168.219.64, change it with your IP):
    [plugins."io.containerd.grpc.v1.cri".registry]
      [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."192.168.219.64:5000"]
          endpoint = ["http://192.168.219.64:5000"]
    [plugins."io.containerd.grpc.v1.cri".registry.configs]
      [plugins."io.containerd.grpc.v1.cri".registry.configs."192.168.219.64:5000".tls]
        insecure_skip_verify = true
# restart containerd.service
sudo systemctl restart containerd.service
```

![image](https://user-images.githubusercontent.com/10358317/157726335-fc7091da-2300-4f4e-a9da-6416a6810329.png)


- If registry IP and the port is not defined, you will get this error:  "http: server gave HTTP response to HTTPS client.
- If pod's status is ImagePullBackOff (Error), it can be inspected with describe command:

```
kubectl describe pods my-private-pod
```

![image](https://user-images.githubusercontent.com/10358317/157730392-09a1a2b6-0eec-4f68-97e9-066d00ea541d.png)


- On Master:

```
kubectl apply -f nginx_pod.yaml
kubectl get pods -o wide
```
![image](https://user-images.githubusercontent.com/10358317/157725926-90b57357-cf8f-4d27-a91c-01a7d0eb047c.png)

### Reference
 
 - https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
 - https://github.com/aytitech/k8sfundamentals/tree/main/setup
 - https://multipass.run/
 - https://computingforgeeks.com/join-new-kubernetes-worker-node-to-existing-cluster/
 - https://docs.docker.com/engine/install/ubuntu/
 - https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
 - https://stackoverflow.com/questions/32726923/pulling-images-from-private-registry-in-kubernetes
 - https://stackoverflow.com/questions/65681045/adding-insecure-registry-in-containerd
