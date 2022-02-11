## App: K8s Rollout - Rollback 

This scenario shows:
- how to roll out deployments with 2 different strategy: recreate and rollingUpdate,
- how to save/record deployments' revision while rolling out with "--record" (e.g. changing image):
  - imperative:             "kubectl set image deployment rcdeployment nginx=httpd --record",
  - declerative, edit file: "kubectl edit deployment rolldeployment --record", 
- how to rollback (rollout undo) the desired deployment revisions: 
  - "kubectl rollout undo deployment rolldeployment --to-revision=2",
- how to pause/resume rollout:
  - pause:  "kubectl rollout pause deployment rolldeployment",
  - resume: "kubectl rollout resume deployment rolldeployment",
- how to see the status of rollout deployment:
  - "kubectl rollout status deployment rolldeployment -w". 

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
    type: RollingUpdate              # deployment roll up strategy: rollingUpdate => Pods are updated step by step, all pods are not deleted at the same time.
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

- Run deployment: 

![image](https://user-images.githubusercontent.com/10358317/153604472-8af9e7d9-7d22-47e2-b02d-2e6c36c86de5.png)

- Watching pods' status (on linux: "watch kubectl get pods", on win: "kubectl get pods -w")

![image](https://user-images.githubusercontent.com/10358317/153604648-9944dfd4-3148-4e8c-b52b-ef801a695ed2.png)

- Watching replica set's status (on linux: "watch kubectl get rs", on win: "kubectl get rs -w")

![image](https://user-images.githubusercontent.com/10358317/153604880-a0697649-967d-4255-bc4d-e72446568844.png)

- Update image version ("kubectl set image deployment rcdeployment nginx=httpd"), after new replicaset and pods are created, old ones are deleted. 

![image](https://user-images.githubusercontent.com/10358317/153605645-3bd72a89-9840-4d6b-9c6c-3b8c251cf2e9.png)

- With "recreate" strategy, pods are terminated:
 
![image](https://user-images.githubusercontent.com/10358317/153605318-8f71959d-3c44-4c72-bdd5-674aea6d1afc.png)

- New pods are creating:

![image](https://user-images.githubusercontent.com/10358317/153605365-bc6ffcbe-cadc-4760-b85a-a4844fa1ccb4.png)

- New replicaset created:

![image](https://user-images.githubusercontent.com/10358317/153605416-80d63de8-dee6-4131-bb24-a1a8f8e47cda.png)

- Delete this deployment:

![image](https://user-images.githubusercontent.com/10358317/153605871-6ca3810d-ce23-4442-ae2c-44c362ada13d.png)

- Run deployment (rolling-deployment.yaml): 

![image](https://user-images.githubusercontent.com/10358317/153610269-96541251-b039-4393-87e3-a1e93e234753.png)


- Watching pods' status (on linux: "watch kubectl get pods", on win: "kubectl get pods -w")

![image](https://user-images.githubusercontent.com/10358317/153610371-5836cf65-2a60-4e94-b96e-e4b8643412a2.png)

- Watching replica set's status (on linux: "watch kubectl get rs", on win: "kubectl get rs -w")

![image](https://user-images.githubusercontent.com/10358317/153610454-e27200ec-1c52-48aa-89de-c798fa6d8d5f.png)

- Run: "kubectl edit deployment rolldeployment --record", it opens vim editor on linux to edit
- Find image definition, press "i" for insert mode, change to "httpd" instead of "nginx", press "ESC", press ":wq" to save and exit

![image](https://user-images.githubusercontent.com/10358317/153610924-b2fc3730-de65-4138-8ee8-d4675badd651.png)

- New pods are creating with new version:

![image](https://user-images.githubusercontent.com/10358317/153614766-027ee933-0788-4418-8577-70f0860a8841.png)

- New replicaset created:

![image](https://user-images.githubusercontent.com/10358317/153614901-55137709-b79a-4bfd-866b-a259b299cda5.png)

- Run new deployment version:

![image](https://user-images.githubusercontent.com/10358317/153615453-95067330-5056-4103-a396-db2979d0b98a.png)

- New pods are creating with new version:

![image](https://user-images.githubusercontent.com/10358317/153615342-043787b0-bb8a-438b-ba35-65e0a71985ac.png)

- New replicaset created:

![image](https://user-images.githubusercontent.com/10358317/153615533-9af6f608-c94b-4a45-baf9-c68d394a3308.png)

- To show history of the deployments (**important:** --record should be used to add old deployment versions in the history list):

![image](https://user-images.githubusercontent.com/10358317/153615727-30cfa59d-a144-41ed-9685-f4ec8a562ed0.png)

- To show/describe the selected revision:

![image](https://user-images.githubusercontent.com/10358317/153616272-3fd95a8b-3b6c-42a7-add6-ae40550a47e8.png)

- Rollback to the revision=1 (with undo: "kubectl rollout undo deployment rolldeployment --to-revision=1"):

![image](https://user-images.githubusercontent.com/10358317/153616842-e5a544c8-0d1b-4843-a263-d7fb7c51df22.png)


- Pod status:

![image](https://user-images.githubusercontent.com/10358317/153616616-30b635d2-c95f-47ea-8abd-5fdcd4646719.png)

- Replicaset revision=1:

![image](https://user-images.githubusercontent.com/10358317/153616770-5c72a691-8028-4bc1-9111-b1f63504b7c7.png)

- It is possible to return from revision=1 to revision=2 (with undo: "kubectl rollout undo deployment rolldeployment --to-revision=2"):

![image](https://user-images.githubusercontent.com/10358317/153618994-f5b072c7-c758-46ce-bcb6-1c48e255200e.png)


- It is also to pause rollout:

![image](https://user-images.githubusercontent.com/10358317/153617586-011a90d9-d4b7-4813-b191-75069ee5ffd0.png)

- While rollback to the revision=3 from revision=2, it was paused:

![image](https://user-images.githubusercontent.com/10358317/153617783-da05f8a8-5b1b-4473-9bd6-47f709ab8349.png)

- Resume the pause of rollout of deployment:

![image](https://user-images.githubusercontent.com/10358317/153617914-3ed84d3f-20a0-4693-bb9e-17e1346f28b5.png)

- Now deployment's revision is 3:

![image](https://user-images.githubusercontent.com/10358317/153618035-5b506540-dc63-45fd-af83-d2bedb5b192e.png)

- It is also possible to see the logs of rollout with:
  - "kubectl rollout status deployment rolldeployment -w"
