## LAB: K8s Service Implementations (ClusterIp, NodePort and LoadBalancer)

This scenario shows how to create Services (ClusterIp, NodePort and LoadBalancer). It goes following:
- Create Deployments for frontend and backend.
- Create ClusterIP Service to reach backend pods.
- Create NodePort Service to reach frontend pods from Internet.
- Create Loadbalancer Service on the cloud K8s cluster to reach frontend pods from Internet.


![image](https://user-images.githubusercontent.com/10358317/149774101-d4cfa70a-f461-4d9d-b2c4-f29de65e0e8b.png) (Ref: Udemy Course: Kubernetes-Temelleri)

### Steps

- Create 3 x front-end and 3 x back-end Pods with following YAML file run ("kubectl apply -f pods.yaml")
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  labels:
    team: development
spec:
  replicas: 3
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: ozgurozturknet/k8s:latest
        ports:
        - containerPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  labels:
    team: development
spec:
  replicas: 3
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: ozgurozturknet/k8s:backend
        ports:
        - containerPort: 5000
```

![image](https://user-images.githubusercontent.com/10358317/154670356-f3bcda44-60d3-4d85-a620-920345c5e026.png)

- Run on the terminal: "kubectl get pods -w" (on Linux/WSL2: "watch kubectl get pods")


![image](https://user-images.githubusercontent.com/10358317/149765878-94ec4173-a6ab-4953-9fb2-c1ffff61e4b2.png)

- Create ClusterIP service that connects to backend (selector: app: backend) (run: "kubectl apply -f backend_clusterip.yaml"). 

``` 
apiVersion: v1
kind: Service
metadata:
  name: backend
spec:
  type: ClusterIP
  selector:
    app: backend
  ports:
    - protocol: TCP
      port: 5000
      targetPort: 5000
``` 

![image](https://user-images.githubusercontent.com/10358317/154670246-fe3466b9-e0d2-42f2-a6e2-37be9e0410bb.png)


- ClusterIP Service created. If any resource in the cluster sends a request to the ClusterIP and Port 5000, this request will reach to one of the pod behind the ClusterIP Service.
- We can show it from frontend pods. 
- Connect one of the front-end pods (list: "kubectl get pods",  connect: "kubectl exec -it frontend-5966c698b4-b664t -- bash")
- In the K8s, there is DNS server (core dns based) that provide us to query ip/name of service.
- When running nslookup (backend), we can reach the complete name and IP of this service (serviceName.namespace.svc.cluster_domain, e.g. backend.default.svc.cluster.local).
- When running curl to the one of the backend pods with port 5000, service provides us to make connection with one of the backend pods.
    
![image](https://user-images.githubusercontent.com/10358317/149767889-29c64bd6-54bf-42bf-b12b-ed83ffedb0a8.png)

- Create NodePort Service to reach frontend pods from the outside of the cluster.
```
apiVersion: v1
kind: Service
metadata:
  name: frontend
spec:
  type: NodePort
  selector:
    app: frontend
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

![image](https://user-images.githubusercontent.com/10358317/154983087-ed031df1-ed5f-4910-b8bd-3bf7197954b2.png)

- With NodePort Service (you can see the image below), frontend pods can be reachable from the opening port (32098). In other words, someone can reach frontend pods via WorkerNodeIP:32098. NodePort service listens all of the worker nodes' port (in this example: port 32098).     
- While working with minikube, it is only possible with minikube tunnelling. Minikube simulates the reaching of the NodeIP:Port with tunneling feature. 

![image](https://user-images.githubusercontent.com/10358317/149769823-a9e00708-c614-41dc-bb73-321483ccf0f3.png)

- On the other terminal, if we run the curl command, we can reach the frontend pods. 

![image](https://user-images.githubusercontent.com/10358317/149770958-87b0c840-92b3-4f9d-81cc-84e725381bf3.png)

- LoadBalancer Service is only available wih cloud services (because in the local cluster, it can not possible to get external-ip of the load-balancer service). So if you have connection to the one of the cloud service (Azure-AKS, AWS EKS, GCP GKE), please create loadbalance service on it. 

```
apiVersion: v1
kind: Service
metadata:
  name: frontendlb
spec:
  type: LoadBalancer
  selector:
    app: frontend
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

![image](https://user-images.githubusercontent.com/10358317/154983532-a14b0046-e3a0-48a2-9784-965b80de4f72.png)

- If you run on the cloud, you'll see the external-ip of the loadbalancer service. 

![image](https://user-images.githubusercontent.com/10358317/149772479-a6262368-ab70-4c79-9897-a8162d5dc767.png)

![image](https://user-images.githubusercontent.com/10358317/149772584-705ab659-4e5e-496e-999c-cabaf3c5a9d2.png)

- In addition, it can be possible service with Imperative way (with command).
- kubectl expose deployment <deploymentName> --type=<typeOfService> --name=<nameOfService>

![image](https://user-images.githubusercontent.com/10358317/149773190-44d11369-ee98-400b-b84a-57527fc1fba7.png)
  
## References  <a name="references"></a>
- [udemy-course:Kubernetes-Temelleri](https://www.udemy.com/course/kubernetes-temelleri/)  
