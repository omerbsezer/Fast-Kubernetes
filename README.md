# Fast-Kubernetes
This repo covers Kubernetes details (Kubectl, Pod, Deployment, Service, ConfigMap, ReplicaSet, PV, PVC, Secret, Kubeadm, etc.) fastly, and possible example usage scenarios (HowTo: Applications) in a nutshell. Possible usage scenarios are aimed to update over time.

## Prerequisite
- Have a knowledge of Container Technology. You can learn it from here => [Fast-Docker](https://github.com/omerbsezer/Fast-Docker)

**Keywords:** Containerization, Kubernetes, Kubectl, Pod, Deployment, Service, ConfigMap, ReplicaSet, Volume, Cheatsheet.

# Quick Look (HowTo)
- [App: Creating First Docker Image and Container using Docker File](https://github.com/omerbsezer/Fast-Docker/blob/main/FirstImageFirstContainer.md)
- [Kubectl Commands Cheatsheet](https://github.com/omerbsezer/Fast-Docker/blob/main/DockerCommandCheatSheet.md)

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

Download
- **Kubectl:** The Kubernetes command-line tool, kubectl, allows you to run commands against Kubernetes clusters. 
- **Minikube:** It is a tool that lets you run Kubernetes locally. It runs a single-node Kubernetes cluster on your personal computer 
- **KubeAdm:** You can use the kubeadm tool to create and manage Kubernetes clusters. This is for creating cluster with computers.

from here=> https://kubernetes.io/docs/tasks/tools/ 

For learning K8s and running on a computer, Kubectl and Minikube are enough to install

### Kubectl Config – Usage <a name="kubectl"></a>

### Pod: Creating, Yaml, LifeCycle <a name="pod"></a>

### MultiContainer Pod, Init Container <a name="multicontainerpod"></a>

### Label and Selector, Annotation, Namespace <a name="labelselector"></a>

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

Goto: [Kubernetes Commands Cheatsheet]()

## Other Useful Resources Related Docker  <a name="resource"></a>
- [KubernetesTutorial](https://kubernetes.io/docs/tutorials/)

- Docker and Kubernetes Tutorial | Full Course [2021] - Youtube: https://www.youtube.com/watch?v=bhBSlnQcq2k&t=3088s

## References  <a name="references"></a>
- [Kubernetes.io](https://kubernetes.io/docs/concepts/overview/)
- [KubernetesTutorial](https://kubernetes.io/docs/tutorials/)
- [udemy-course:adan-zye-docker](https://www.udemy.com/course/adan-zye-docker/)
