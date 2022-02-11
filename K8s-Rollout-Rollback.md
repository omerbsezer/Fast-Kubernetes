## App: K8s Rollout - Rollback 

This scenario shows:
- how to create multicontainer in one pod,
- how the multicontainers in the same pod have same ethernet interface (IPs),
- how the multicontainers in the same pod can reach the shared volume area,
- how to make port-forwarding to host PC ports

### Steps

- Run minikube  (in this scenario, K8s runs on WSL2- Ubuntu 20.04) ("minikube start")

  ![image](https://user-images.githubusercontent.com/10358317/153183333-371fe598-d5a4-4b86-9b5d-9e33f35063cc.png)
  
- Create Yaml file (recreate-deployment.yaml) in your directory and copy the below definition into the file:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rcdeployment
  labels:
    team: development
spec:
  replicas: 5                        # create 5 replicas
  selector:
    matchLabels:                     # labelselector of deployment: selects pods which have "app:recreate" labels
      app: recreate
  strategy:                          # deployment roll up strategy: recreate => Delete all pods firstly and create Pods from scratch.
    type: Recreate
  template:
    metadata:
      labels:                        # labels the pod with "app:recreate" 
        app: recreate
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```

- Create Yaml file (rolling-deployment.yaml) in your directory and copy the below definition into the file:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rolldeployment
  labels:
    team: development
spec:
  replicas: 10                     
  selector:
    matchLabels:                     # labelselector of deployment: selects pods which have "app:rolling" labels
      app: rolling
  strategy:
    type: RollingUpdate              # deployment roll up strategy: rolling => Pods are updated step by step, all pods are not deleted at the same time.
    rollingUpdate:                   
      maxUnavailable: 2              # shows the max number of deleted containers => total:10 container; if maxUnava:2, min:8 containers run in that time period
      maxSurge: 2                    # shows that the max number of containers    => total:10 container; if maxSurge:2, max:12 containers run in a time
  template:
    metadata:
      labels:                        # labels the pod with "app:rolling"
        app: rolling
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```
