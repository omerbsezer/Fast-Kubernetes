## LAB: K8s Taint Toleration

This scenario shows:
- how to label the node,
- when node is not labelled and pods' nodeAffinity are defined, pods always wait pending 


### Steps

- Run minikube  (in this scenario, K8s runs on WSL2- Ubuntu 20.04) ("minikube start")

![image](https://user-images.githubusercontent.com/10358317/153183333-371fe598-d5a4-4b86-9b5d-9e33f35063cc.png)

- Create Yaml file (podtoleration.yaml) in your directory and copy the below definition into the file:

``` 
apiVersion: v1
kind: Pod
metadata:
  name: toleratedpod1
  labels:
    env: test
spec:
  containers:
  - name: toleratedcontainer1
    image: nginx:latest
  tolerations:                    # pod tolerates "app=production:NoSchedule"
  - key: "app"
    operator: "Equal"
    value: "production"
    effect: "NoSchedule"
---
apiVersion: v1
kind: Pod
metadata:
  name: toleratedpod2
  labels:
    env: test
spec:
  containers:
  - name: toleratedcontainer2
    image: nginx:latest
  tolerations:
  - key: "app"                     # pod tolerates "app:NoSchedule", value is not important in this pod
    operator: "Exists"             # pod can run on the nodes which has "app=test:NoSchedule" or "app=production:NoSchedule"
    effect: "NoSchedule" 
```

- When we look at the node details, there is not any taint on the node (minikube):
```
kubectl describe node minikube
```
![image](https://user-images.githubusercontent.com/10358317/153669930-0ef1e295-f11d-49a3-9df0-4caae0a43349.png)

- Add taint to the node (minikube):
```
kubectl taint node minikube platform=production:NoSchedule
```
![image](https://user-images.githubusercontent.com/10358317/153670171-a5c3366b-c996-4d45-acd3-33dada7222b8.png)

- Create pod that does not tolerate the taint:
```
kubectl run test --image=nginx --restart=Never
```
![image](https://user-images.githubusercontent.com/10358317/153670451-f7a2657b-9c34-413e-8a00-b4c5f645e088.png)

- This pod always waits as pending, because it is not tolerated the taints:

![image](https://user-images.githubusercontent.com/10358317/153670590-3477dd11-d328-4291-96fa-8b811a301037.png)

![image](https://user-images.githubusercontent.com/10358317/153670825-0c2e7736-0d1c-4b97-be57-0fbae607ccc6.png)


- In the yaml file above (podtoleration.yaml), we have 2 pods that tolerates this taint => "app=production:NoSchedule"
- Create these 2 pods:

![image](https://user-images.githubusercontent.com/10358317/153671055-2bf48e13-abbe-46dd-8dd6-14274109a503.png)

- These pods tolerate the taint and they are running on the node, but "test" does not tolerate the taint, it still waits:

![image](https://user-images.githubusercontent.com/10358317/153671160-c96e5084-4314-486b-9d57-850acf63e973.png)

- But if we define another taint with "NoExecute", running pods are terminated:
```
kubectl taint node minikube version=new:NoExecute
```
![image](https://user-images.githubusercontent.com/10358317/153671667-f5901893-9a9b-4f59-b482-30639432c0af.png)

![image](https://user-images.githubusercontent.com/10358317/153672106-436e0268-82e1-40da-990f-9d98fbfd44ca.png)

- Delete taint from the node:
```
kubectl taint node minikube version-
```
![image](https://user-images.githubusercontent.com/10358317/153672236-97528ceb-aedd-4bb4-b8b1-172215027237.png)

- Delete minikube:

![image](https://user-images.githubusercontent.com/10358317/153672400-2d2b7843-5acb-4e8a-8a3b-5aef04dc2a80.png)
