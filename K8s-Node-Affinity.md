## LAB: K8s Node Affinity

This scenario shows:
- how to label the node,
- when node is not labelled and pods' nodeAffinity are defined, pods always wait pending 


### Steps

- Run minikube  (in this scenario, K8s runs on WSL2- Ubuntu 20.04) ("minikube start")

![image](https://user-images.githubusercontent.com/10358317/153183333-371fe598-d5a4-4b86-9b5d-9e33f35063cc.png)

- Create Yaml file (podnodeaffinity.yaml) in your directory and copy the below definition into the file:

``` 
apiVersion: v1
kind: Pod
metadata:
  name: nodeaffinitypod1
spec:
  containers:
  - name: nodeaffinity1
    image: nginx:latest                                     # "requiredDuringSchedulingIgnoredDuringExecution" means
  affinity:                                                 # Find a node during scheduling according to "matchExpression" and run pod on that node. 
    nodeAffinity:                                           # If it is not found, do not run this pod until finding specific node "matchExpression".
      requiredDuringSchedulingIgnoredDuringExecution:       # "...IgnoredDuringExecution" means  
        nodeSelectorTerms:                                  # after scheduling, if the node label is removed/deleted from node, ignore it while executing. 
        - matchExpressions:
          - key: app
            operator: In                                    # In, NotIn, Exists, DoesNotExist
            values:                                         # In => key=value,    NotIn => key!=value
            - production                                    # Exists => only key   
---
apiVersion: v1
kind: Pod
metadata:
  name: nodeaffinitypod2
spec:
  containers:
  - name: nodeaffinity2
    image: nginx:latest
  affinity:                                                 # "preferredDuringSchedulingIgnoredDuringExecution" means
    nodeAffinity:                                           # Find a node during scheduling according to "matchExpression" and run pod on that node. 
      preferredDuringSchedulingIgnoredDuringExecution:      # If it is not found, run this pod wherever it finds.
      - weight: 1                                           # if there is a pod with "app=production", run on that pod
        preference:                                         # if there is NOT a pod with "app=production" and there is NOT any other preference, 
          matchExpressions:                                 # run this pod wherever scheduler finds a node. 
          - key: app
            operator: In
            values:
            - production
      - weight: 2                                           # this is highest prior, weight:2 > weight:1
        preference:                                         # if there is a pod with "app=test", run on that pod
          matchExpressions:                                 # if there is NOT a pod with "app=test", goto weight:1 preference
          - key: app
            operator: In
            values:
            - test
---
apiVersion: v1
kind: Pod
metadata:
  name: nodeaffinitypod3
spec:
  containers:
  - name: nodeaffinity3
    image: nginx:latest
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: app
            operator: Exists                                # In, NotIn, Exists, DoesNotExist
```

- Create pods:
  - 1st pod waits pending: Because it controls labelled "app:production" node, but it does not find, so it waits until finding labelled "app:production" node.
  - 2nd pod started: Because it controls the labels first, but "preferredDuringScheduling", even if it does not find, run anywhere.
  - 3rd pod waits pending: Because it controls labelled "app" node, but it does not find, so it waits until finding labelled "app" node.
  
![image](https://user-images.githubusercontent.com/10358317/153663079-4ce6a3cd-68a5-4df7-af2b-8c7a9bb3ea67.png)

- After labelling node with label "app:production", 1st and 3rd nodes also run on the same node. Because they find the required label. 

```
kubectl label node minikube app=production
```
![image](https://user-images.githubusercontent.com/10358317/153664135-9752ca3b-6154-41bd-a026-7bb063bdbf23.png)

- After unlabelling the node, all pods still run due to "IgnoredDuringExecution". Node ignores the label controlling after execution.

```
kubectl label node minikube app-
```

![image](https://user-images.githubusercontent.com/10358317/153664599-b6426c70-93c3-45a7-95bf-721cded025e7.png)

- Delete pods:

![image](https://user-images.githubusercontent.com/10358317/153665104-11406023-86c5-456b-89a8-7ba486f2c560.png)


