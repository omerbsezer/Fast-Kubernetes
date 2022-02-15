## LAB: K8s Deployment - Scale Up/Down - Bash Connection - Port Forwarding

This scenario shows:
- how to create deployment,
- how to get detail information of deployment and pods,
- how to scale up and down of deployment,
- how to connect to the one of the pods with bash,
- how to show ethernet interfaces of the pod and ping other pods,
- how to forward ports to see nginx server page using browser.

### Steps

- Run minikube  (in this scenario, K8s runs on WSL2- Ubuntu 20.04) ("minikube start")

  ![image](https://user-images.githubusercontent.com/10358317/153183333-371fe598-d5a4-4b86-9b5d-9e33f35063cc.png)
  
- Create Yaml file (deployment1.yaml) in your directory and copy the below definition into the file:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: firstdeployment
  labels:
    team: development
spec:
  replicas: 3
  selector:                        # deployment selector
    matchLabels:                   # deployment selects "app:frontend" pods, monitors and traces these pods 
      app: frontend                # if one of the pod is killed, K8s looks at the desire state (replica:3), it recreats another pods to protect number of replicas
  template:
    metadata:
      labels:                      # pod labels, if the deployment selector is same with these labels, deployment follows pods that have these labels         
        app: frontend              # key: value        
    spec:                                   
      containers:
      - name: nginx                
        image: nginx:latest        # image download from DockerHub
        ports:
        - containerPort: 80        # open following ports
```

![image](https://user-images.githubusercontent.com/10358317/154119883-5ffcaaaa-572e-427e-b6d6-65e3a8723121.png)


- Create deployment and list the deployment's pods:

![image](https://user-images.githubusercontent.com/10358317/153439583-c445b070-ac27-4838-8943-466261abf635.png)

- Delete one of the pod, then K8s automatically creates new pod:

![image](https://user-images.githubusercontent.com/10358317/153440362-a95dbc41-2cc0-4ec6-8830-8924f3c4a2f7.png)

- Scale up to 5 replicas:

![image](https://user-images.githubusercontent.com/10358317/153440932-39f98de1-c129-4d7d-a4e6-79acbed070ea.png)

- Scale down to 3 replicas:

![image](https://user-images.githubusercontent.com/10358317/153441111-558460c7-e35e-4db3-9028-50b6c9149043.png)

- Get more information about pods (ip, node):

![image](https://user-images.githubusercontent.com/10358317/153442941-da17b07e-ad14-49ae-84b3-d9902535f9a7.png)


- Connect one of the pod with bash:

![image](https://user-images.githubusercontent.com/10358317/153442294-efb4dfa5-0753-404c-b1bf-896a8d8ed436.png)

- To install ifconfig, run: "apt update", "apt install net-tools"
- To install ping, run: "apt install iputils-ping"
- Show ethernet interfaces:

![image](https://user-images.githubusercontent.com/10358317/153442647-32ea74cd-dd46-4631-b896-f90ec1afb1a3.png)

- Ping other pods:

![image](https://user-images.githubusercontent.com/10358317/153443214-d0e3dc55-e4ef-449a-8b9e-35a45ecb2675.png)

- Port-forward from one of the pod to host (8085:80):

![image](https://user-images.githubusercontent.com/10358317/153443668-18071c34-0e80-4ecd-a3e9-ae9570bd9d7d.png)

- On the browser, goto http://127.0.0.1:8085/

![image](https://user-images.githubusercontent.com/10358317/153443803-709fdf31-7d16-4268-a1f1-8fc822abc471.png)

- Delete deployment:

![image](https://user-images.githubusercontent.com/10358317/153444098-e52f2cde-3fd2-4606-b68c-89e6f9194398.png)

