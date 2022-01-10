# Fast-Kubernetes
This repo covers Kubernetes details (Kubectl, Pod, Deployment, Service, ConfigMap, ReplicaSet, PV, PVC, Secret, Kubeadm, etc.) fastly, and possible example usage scenarios (HowTo: Applications) in a nutshell. Possible usage scenarios are aimed to update over time.

## Prerequisite
- Have a knowledge of Container Technology. You can learn it from here => [Fast-Docker](https://github.com/omerbsezer/Fast-Docker)

**Keywords:** Containerization, Kubernetes, Kubectl, Pod, Deployment, Service, ConfigMap, ReplicaSet, Volume, Cheatsheet.

# Quick Look (HowTo)
- [App: Creating First Pod Image Declerative Way (With File)]()
- [App: Multicontainer in a Pod: Sidecar and Volume Application]()
- [Kubectl Commands Cheatsheet](https://github.com/omerbsezer/Fast-Kubernetes/blob/main/KubernetesCommandCheatSheet.md)

# Table of Contents
- [Motivation](#motivation)
    - [What is Containerization? What is Container Orchestration?](#containerization)
    - [Features](#features)
- [What is Kubernetes?](#whatIsKubernetes)
    - [Kubertenes Architecture](#architecture)
    - [Kubernetes Components](#components)
    - [Installation](#installation)
    - [Kubectl Config – Usage](#kubectl)
    - [Pod: Creating, Yaml, LifeCycle](#pod)
    - [MultiContainer Pod, Init Container](#multicontainerpod)
    - [Label and Selector, Annotation, Namespace](#labelselector)
    - [Deployment](#deployment)
    - [Replicaset](#replicaset)
    - [Rollout and Rollback](#rollout-rollback)
    - [Network, Service](#network-service)
    - [Liveness and Readiness Probe](#liveness-readiness)
    - [Resource Limit, Environment Variable](#environmentvariable)
    - [Volume](#volume)
    - [Secret](#secret)
    - [ConfigMap](#configmap)
    - [Node – Pod Affinity](#node-pod-affinity)
    - [Taint and Toleration](#taint-tolereation)
    - [Deamon Set](#daemon-set)
    - [Persistent Volume and Persistent Volume Claim](#pvc)
    - [Storage Class](#storageclass)
    - [Stateful Set](#statefulset)
    - [Job, CronJob](#job)
    - [Ingress](#ingress)
- [Play With Kubernetes](#playWithKubernetes)
- [Kuberbetes Package Manager: Helm](#helm)
- [Kubernetes Commands Cheatsheet](#cheatsheet)
- [Other Useful Resources Related Kubernetes](#resource)
- [References](#references)

## Motivation <a name="motivation"></a>
Why should we use Kubernetes? "Kubernetes is a portable, extensible, open-source platform for managing containerized workloads and services, that facilitates both declarative configuration and automation. It has a large, rapidly growing ecosystem. Kubernetes services, support, and tools are widely available." (Ref: Kubernetes.io)

### What is Containerization? What is Container Orchestration? <a name="containerization"></a>
- "Containerization is an operating system-level virtualization or application-level virtualization over multiple network resources so that software applications can run in isolated user spaces called containers in any cloud or non-cloud environment" (wikipedia)
- With Docker Environment, we can create containers.
- Kubernetes and Docker Swarm are the container orchestration and management tools that automate and schedule the deployment, management, scaling, and networking of containers.

![image](https://user-images.githubusercontent.com/10358317/146249579-b4221dc1-bad7-4da5-831a-849a71fa849e.png)

### Features <a name="features"></a>
- **Service discovery and load balancing:** Kubernetes can expose a container using the DNS name or using their own IP address. If traffic to a container is high, Kubernetes is able to load balance and distribute the network traffic so that the deployment is stable.
- **Storage orchestration:** Kubernetes allows you to automatically mount a storage system of your choice, such as local storages, public cloud providers, and more.
- **Automated rollouts and rollbacks:**  You can describe the desired state for your deployed containers using Kubernetes, and it can change the actual state to the desired state at a controlled rate. 
- **Automatic bin packing:** You tell Kubernetes how much CPU and memory (RAM) each container needs. Kubernetes can fit containers onto your nodes to make the best use of your resources.
- **Self-monitoring:** Kubernetes checks constantly the health of nodes and containers
- **Self-healing:** Kubernetes restarts containers that fail, replaces containers, kills containers that don't respond to your user-defined health check
- **Automates various manual processes:** for instance, Kubernetes will control for you which server will host the container, how it will be launched etc.
- **Interacts with several groups of containers:** Kubernetes is able to manage more cluster at the same time
- **Provides additional services:** as well as the management of containers, Kubernetes offers security, networking and storage services
- **Horizontal scaling:** Kubernetes allows you scaling resources not only vertically but also horizontally, easily and quickly
- **Container balancing:** Kubernetes always knows where to place containers, by calculating the “best location” for them
- **Run everywhere:** Kubernetes is an open source tool and gives you the freedom to take advantage of on-premises, hybrid, or public cloud infrastructure, letting you move workloads to anywhere you want
- **Secret and configuration management:** Kubernetes lets you store and manage sensitive information

## What is Kubertenes?  <a name="whatIsKubernetes"></a>
- "Kubernetes is a portable, extensible, open-source platform for managing containerized workloads and services, that facilitates both declarative configuration and automation. It has a large, rapidly growing ecosystem. Kubernetes services, support, and tools are widely available." (Ref: Kubernetes.io)

![image](https://user-images.githubusercontent.com/10358317/146247396-5bc3bbf9-41fa-47ff-b10d-cac305379e21.png) (Ref: Kubernetes.io)

### Kubertenes Architecture  <a name="architecture"></a>

![image](https://user-images.githubusercontent.com/10358317/146250114-18759a06-e6a6-4554-bc7f-b23a13534f77.png)

### Kubernetes Components <a name="components"></a> (Ref: Kubernetes.io)
- **Control Plane:** User enters commands and configuration files from control plane. It controls all cluster.
    - **API Server:** "It exposes the Kubernetes API. The API server is the front end for the Kubernetes control plane."
    - **Etcd:** "Consistent and highly-available key value store used as Kubernetes' backing store for all cluster data (meta data, objects, etc.)."
    - **Scheduler:** "It watches for newly created Pods with no assigned node, and selects a node for them to run on. 
        -  Factors taken into account for scheduling decisions include: 
            -  individual and collective resource requirements, 
            -  hardware/software/policy constraints, 
            -  affinity and anti-affinity specifications, 
            -  data locality, 
            -  inter-workload interference,
            -  deadlines."
    - **Controller Manager:** "It runs controller processes.
        - Logically, each controller is a separate process, but to reduce complexity, they are all compiled into a single binary and run in a single process.
        - Some types of these controllers are:
            - Node controller: Responsible for noticing and responding when nodes go down.
            - Job controller: Watches for Job objects that represent one-off tasks, then creates Pods to run those tasks to completion.
            - Endpoints controller: Populates the Endpoints object (that is, joins Services & Pods).
            - Service Account & Token controllers: Create default accounts and API access tokens for new namespaces"
     - **Cloud Controller Manager:** "It embeds cloud-specific control logic. The cloud controller manager lets you link your cluster into your cloud provider's API, and separates out the components that interact with that cloud platform from components that only interact with your cluster. The cloud-controller-manager only runs controllers that are specific to your cloud provider
        -  The following controllers can have cloud provider dependencies:
            - Node controller: For checking the cloud provider to determine if a node has been deleted in the cloud after it stops responding
            - Route controller: For setting up routes in the underlying cloud infrastructure
            - Service controller: For creating, updating and deleting cloud provider load balancers."
- **Node:** "Node components run on every node, maintaining running pods and providing the Kubernetes runtime environment."
    - **Kubelet:** "An agent that runs on each node in the cluster. It makes sure that containers are running in a Pod. The kubelet takes a set of PodSpecs that are provided through various mechanisms and ensures that the containers described in those PodSpecs are running and healthy."
    - **Kube-proxy:** "It is a network proxy that runs on each node in your cluster, implementing part of the Kubernetes Service concept.
        - It maintains network rules on nodes. These network rules allow network communication to your Pods from network sessions inside or outside of your cluster.
        - It uses the operating system packet filtering layer if there is one and it's available. Otherwise, kube-proxy forwards the traffic itself."
    - **Container Runtime:** "The container runtime is the software that is responsible for running containers.
        -  Kubernetes supports several container runtimes: **Docker, containerd, CRI-O,** and any implementation of the Kubernetes CRI (Container Runtime Interface)"  

![image](https://user-images.githubusercontent.com/10358317/146250916-a9298521-526b-451a-9810-6813e4165db5.png)

### Installation <a name="installation"></a>

Download:
- **Kubectl:** The Kubernetes command-line tool, kubectl, allows you to run commands against Kubernetes clusters. 
- **Minikube:** It is a tool that lets you run Kubernetes locally. It runs a single-node Kubernetes cluster on your personal computer 
- **KubeAdm:** You can use the kubeadm tool to create and manage Kubernetes clusters. This is for creating cluster with computers.

from here=> https://kubernetes.io/docs/tasks/tools/ 

For learning K8s and running on a computer, Kubectl and Minikube are enough to install.

**PS:** Cloud providers (Azure, Google Cloud, AWS) offer managed K8s (control plane is managed by cloud provides). You can easily create your cluster (number of computer and details) and make connection with Kubectl (using CLI get-credentials of cluster on the cloud)

### Kubectl Config – Usage <a name="kubectl"></a>
#### Config File
- You can communicate with K8s cluster in different ways: REST API, Command Line Tool (CLI-Kubectl), GUI (kube-dashboard, etc.)
- After installation, you can find the kubernetes config file (C:\Users\User\.kube\config) that is YAML file.
- Config file contains 3 main parts: Clusters (cluster certificate data, server, name), Context (cluster and user, namespace), Users (name, config features, certificates, etc.)

#### Usage
- Kubectl is our main command line tool that connects minikube. There are many combination of commands. So it is not possible to list all commands. 
- When run "kubectl" on the terminal, it can be seen some simple commands. Also "kubectl <command> --help" gives more information.
- Pattern: kubectl [get|delete|edit|apply] [pods|deployment|services] [podName|serviceName|deploymentName]
- Example: "kubectl get pods podName", "kubectl delete pods test_pod", "kubectl describe pods firstpod", etc.
- All necessary/most usable commands are listed in the "[Kubernetes Commands Cheatsheet](https://github.com/omerbsezer/Fast-Kubernetes/blob/main/KubernetesCommandCheatSheet.md)". Please have a look to get more information and usage.

### Pod: Creating, Yaml, LifeCycle <a name="pod"></a>
- Pod is the smallest unit that is created and managed in K8s.
- Pods may contain more than 1 container, but mostly pods contain only 1 container.
- Each pod has unique id (uid).
- Each pod has unique IP address.
- Containers in the same Pod run on the same Node (computer), and these containers can communicate with each other on the localhost. 
- Creation of the first pod, IMPERATIVE WAY (with command):
```
kubectl run firstpod --image=nginx --restart=Never
kubectl get pods -o wide
kubectl describe pods firstpod
kubectl logs -f firstpod   #live log
```
![image](https://user-images.githubusercontent.com/10358317/148650873-8b27afb3-979f-405e-98f5-bc68bbb9b5db.png)

- Run command in the pod:
```
kubectl exec firstpod -- hostname #run 'hostname' command in the firstpod 
kubectl exec firstpod -- ls       #run 'ls' command in the firstpod
```
- Connect to the pod and open shell terminal in the pod:
```
kubectl exec -it firstpod -- /bin/sh
# ls
# exit
```
![image](https://user-images.githubusercontent.com/10358317/148651134-8c770063-6457-4501-8229-2d02b1d3bdae.png)

- Delete the pod:
```
kubectl delete pods firstpod
```
#### Pod: YAML File
- Declerative way (with file), Imperative way (with command)
- Template:
```
apiVersion:
kind:
metadata:
spec:
```
- First pod (nginx) with file (filename: pod1.yaml):
```
apiVersion: v1      
kind: Pod
metadata:
  name: firstpod
  labels:
    app: frontend
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
    env:
      - name: USER
    command: ['sh', '-c', 'echo "Hello, Kubernetes!" && sleep 20']  
```
- Run file (first goto pod1.yaml path):
```
kubectl apply -f pod1.yaml
```
![image](https://user-images.githubusercontent.com/10358317/148652119-59556685-be97-4b39-a5aa-fd5c075425bf.png)

#### Pod: Life Cycle
- **Pending:** API->etcd, pod created, pod id created, but not running on the node.
- **Creating:** Scheduler take pod from etcd, assing on node. Kubelet on the Node pull images from docker registry or repository.
- **ImagePullBackOff:** Kubelet can not pull image from registry. E.g. Image name is fault (typo error), Authorization Failure, Username/Pass error.
- **Running:** 
    - Container closes in 3 ways:
        1. App completes the mission and closes automatically without giving error,
        2. Use or System sends close signal and closes automatically without giving error,
        3. Giving error, collapsed and closes with giving error code. 
    - Rastart Policies (it can defined in the pod definition): 
        1. Always: Default value, kubelet starts always when closing with or without error, 
        2. On-failure: It starts again when it gets only error, 
        3. Never: It never restarts in any case.
 - **Successed (completed)**: If the container closes successfully without error and restart policy is configured as on-failure/never, it converts to succeed.
 - **Failed**
 - **CrashLoopBackOff:** 
    - If restart policy is configured as always and container closes again and again, container restarts again and again (Restart waiting duration before restarting again: 10 sec -> 20 sec -> 40 sec -> .. -> 5mins), It runs every 5 mins if the pod is crashed.
    - If container runs more than 10 mins, status converted from 'CrashLoopBackOff' to 'Running'.

### MultiContainer Pod, Init Container <a name="multicontainerpod"></a>
- Best Practice: 1 Container runs in 1 Pod normally, because the smallest element in K8s is Pod (Pod can be scaled up/down).
- Multicontainers run in the same Pod when containers are dependent of each other. 
- Multicontainers in one Pod have following features:
  - Multi containers that run on the same Pod run on the same Node.
  - Containers in the same Pod run/pause/deleted at the same time.
  - Containers in the same Pod communicate with each other on localhost, there is not any network isolation.
  - Containers in the same Pod use one volume commonly and they can reasch same files in the volume.   

#### Init Container
- Init container is used for configuration of app before running app container. 
- Init container handle what it should run, then it closes successfully, after init container close, app container starts. 
- Example below shows how to define init containers in one Pod. There are 2 containers: appcontainer and initcontainer. Initcontainer is polling the service (myservice). When it finds, it closes and app container starts.  

```
apiVersion: v1
kind: Pod
metadata:
  name: initcontainerpod
spec:
  containers:
  - name: appcontainer
    image: busybox
    command: ['sh', '-c', 'echo The app is running! && sleep 3600']
  initContainers:
  - name: initcontainer
    image: busybox
    command: ['sh', '-c', "until nslookup myservice; do echo waiting for myservice; sleep 2; done"]
```

### Label and Selector, Annotation, Namespace <a name="labelselector"></a>
#### Label
- Label is important to reach the K8s objects with key:value pairs.
- key:value is used for labels. E.g. tier:frontend, stage:test, name:app1, team:development
- prefix may also be used for optional with key:value. E.g. example.com/tier:front-end, kubernetes.io/ , k8s.io/
- In the file (declerative way), labels are added under metadata. It is possible to add multiple labels. 
```
apiVersion: v1
kind: Pod
metadata:
  name: pod1
  labels:
    app: firstapp
    tier: frontend
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
```
- In the command (imperative way), we can also add label to the pods.
```
kubectl label pods pod1 team=development  #adding label team=development on pod1
kubectl get pods --show-labels
kubectl label pods pod1 team-  #remove team (key:value) from pod1
kubectl label --overwrite pods pod1 team=test #overwrite/change label on pod1
kubectl label pods --all foo=bar  # add label foo=bar for all pods
```
#### Selector
- We can select/filter pod with kubectl command. 
```
kubectl get pods -l "app=firstapp" --show-labels
kubectl get pods -l "app=firstapp,tier=frontend" --show-labels
kubectl get pods -l "app=firstapp,tier!=frontend" --show-labels
kubectl get pods -l "app,tier=frontend" --show-labels #equality-based selector
kubectl get pods -l "app in (firstapp)" --show-labels  #set-based selector
kubectl get pods -l "app not in (firstapp)" --show-labels  #set-based selector
kubectl get pods -l "app=firstapp,app=secondapp" --show-labels # comma means and => firstapp and secondapp
kubectl get pods -l "app in (firstapp,secondapp)" --show-labels # it means or => firstapp or secondapp
```
#### Node Selector
- With Node Selector, we can choose which pod run on which Node. 
```
apiVersion: v1
kind: Pod
metadata:
  name: pod11
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
  nodeSelector:
    hddtype: ssd
```
- It is also possible to label nodes with imperative way. 
```
kubectl apply -f podnode.yaml
kubectl get pods -w #always watch
kubectl label nodes minikube hddtype=ssd #after labelling node, pod11 configuration can run, because node is labelled with hddtype:ssd 
```
#### Annotation
- It is similar to label, but it is used for the detailed information (e.g. owner, notification-email, releasedate, etc.) that are not used for linking objects. 

```
apiVersion: v1
kind: Pod
metadata:
  name: annotationpod
  annotations:
    owner: "owner-name"
    notification-email: "owner@email.com"
    releasedate: "01.01.2022"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
spec:
  containers:
  - name: annotationcontainer
    image: nginx
    ports:
    - containerPort: 80
```

```
kubectl apply -f podannotation.yaml
kubectl describe pod annotationpod
kubectl annotate pods annotationpod foo=bar #imperative way
```

### Deployment <a name="deployment"></a>

### Replicaset <a name="replicaset"></a>

### Rollout and Rollback <a name="rollout-rollback"></a>

### Network, Service <a name="network-service"></a>

### Liveness and Readiness Probe <a name="liveness-readiness"></a>

### Resource Limit, Environment Variable <a name="environmentvariable"></a>

### Volume <a name="volume"></a>

### Secret <a name="secret"></a>

### ConfigMap <a name="configmap"></a>

### Node – Pod Affinity <a name="node-pod-affinity"></a>

### Taint and Toleration <a name="taint-tolereation"></a>

### Deamon Set <a name="daemon-set"></a>

### Persistent Volume and Persistent Volume Claim <a name="pvc"></a>

### Storage Class <a name="storageclass"></a>

### Stateful Set <a name="statefulset"></a>

### Job, CronJob <a name="job"></a>

### Ingress <a name="ingress"></a>

## Play With Kubernetes <a name="playWithKubernetes"></a>

- https://labs.play-with-k8s.com/


## Kubernetes Commands Cheatsheet <a name="cheatsheet"></a>

Goto: [Kubernetes Commands Cheatsheet](https://github.com/omerbsezer/Fast-Kubernetes/blob/main/KubernetesCommandCheatSheet.md)

## Other Useful Resources Related Docker  <a name="resource"></a>
- [KubernetesTutorial](https://kubernetes.io/docs/tutorials/)

- Docker and Kubernetes Tutorial | Full Course [2021] - Youtube: https://www.youtube.com/watch?v=bhBSlnQcq2k&t=3088s

## References  <a name="references"></a>
- [Kubernetes.io](https://kubernetes.io/docs/concepts/overview/)
- [KubernetesTutorial](https://kubernetes.io/docs/tutorials/)
- [udemy-course:Kubernetes-Temelleri](https://www.udemy.com/course/kubernetes-temelleri/)
