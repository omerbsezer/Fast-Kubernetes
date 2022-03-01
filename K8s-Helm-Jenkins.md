## Helm-Jenkins on running K8s Cluster (2 Node Multipass VM)

### K8s Cluster (2 Node Multipass VM)
- K8s cluster was created before:
   - **Goto:** [K8s Kubeadm Cluster Setup](https://github.com/omerbsezer/Fast-Kubernetes/blob/main/K8s-Kubeadm-Cluster-Setup.md)

- On that cluster, helm was installed on master node.

### Helm Install

- Installed on Ubuntu 20.04 (for other platforms: https://helm.sh/docs/intro/install/)

```
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
helm version
```
![image](https://user-images.githubusercontent.com/10358317/153708424-d875f4bc-1af5-4169-85af-c87044e64f17.png)


### Jenkins Install

```
helm repo add jenkins https://charts.jenkins.io        
helm repo list
mkdir helm
cd helm
helm pull jenkins/jenkins                                           
tar zxvf jenkins-3.11.4.tgz                                       
```

- After unzipping, entered into the jenkins directory, you'll find values.yaml file. Disable the persistence with false. 
- If your cluster on-premise does not support storage class (like our multipass VM cluster), PVC and PV, disable persistence. But if you are working on minikube, minikube supports PVC and PV automatically. 
- If you don't disable persistence, you'll encounter that your PODs will not run (wait pending). You can inspect PVC, PV and Pod with kubectl describe command. 

![image](https://user-images.githubusercontent.com/10358317/156223521-0982d3d4-61aa-4a33-a068-a634e7382eed.png)

- Install Helm Jenkins Release:
```
helm install j1 jenkins
kubectl get pods
kubectl get svc
kubectl get pods -o wide
```

![image](https://user-images.githubusercontent.com/10358317/156224502-024f42ad-62e6-4887-9058-ae09f3beb91d.png)

- To get Jenkins password (username:admin), run:
```
kubectl exec --namespace default -it svc/j1-jenkins -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo  
```
![image](https://user-images.githubusercontent.com/10358317/156224860-c40406a7-7fbf-45bc-ada5-d4bb54cf1b25.png)

- Port Forwarding:
```
kubectl --namespace default port-forward svc/j1-jenkins 8080:8080
```
![image](https://user-images.githubusercontent.com/10358317/156225021-759b0507-37be-484c-87f3-777c0472e4ba.png)


### Install Graphical Desktop to Reach Browser using Multipass VM

- Install ubuntu-desktop, so you can reach multipass VM's browser using Windows RDP (Xrdp) (https://discourse.ubuntu.com/t/graphical-desktop-in-multipass/16229)

```
sudo apt update
sudo apt install ubuntu-desktop xrdp
sudo passwd ubuntu    # set password
```

### Jenkins Configuration

- Helm also downloads automatically some of the plugins  (kubernetes:1.31.3, workflow-aggregator:2.6, git:4.10.2, configuration-as-code:1.55.1) (Jenkins Version: 2.319.3)
- Manage Jenkins > Configure  System > Cloud
![image](https://user-images.githubusercontent.com/10358317/156225898-1487b783-d112-4fcb-8ffa-66195e2d5f35.png)

![image](https://user-images.githubusercontent.com/10358317/156226068-0afcd9c2-9537-4431-8cdd-954625a73434.png)

![image](https://user-images.githubusercontent.com/10358317/156226209-b05eb0fd-d467-42e0-9fc9-ad1b37cb6efa.png)

![image](https://user-images.githubusercontent.com/10358317/156226315-0dd0f343-d02d-45a3-b2ef-5289ad6dcd03.png)

![image](https://user-images.githubusercontent.com/10358317/156226468-2c09dd57-9d94-426d-ba9d-0c88f865afec.png)

![image](https://user-images.githubusercontent.com/10358317/156226617-caf80b7c-d20b-4cc2-84c3-d42742531cd5.png)

- New Item on main page: 

![image](https://user-images.githubusercontent.com/10358317/156226810-bfafc539-0ab5-4c18-b2ce-68191d5b0e4d.png)

![image](https://user-images.githubusercontent.com/10358317/156226947-78293336-a4ca-468c-b1e7-37247829d261.png)

- Add script > Build > Execute Shell:

![image](https://user-images.githubusercontent.com/10358317/156227131-c9f2a519-2749-405e-ab4a-7ae27c6b2787.png)

- After triggering jobs, Jenkins (on Master) creates agents on Worker1 automatically. After jobs are completed, they are terminated.

![image](https://user-images.githubusercontent.com/10358317/156227423-0dc264b5-9060-46c5-a353-4d15ea64e9fa.png)






