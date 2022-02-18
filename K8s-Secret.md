## LAB: K8s Secret

This scenario shows:
- how to create secrets with file,
- how to use secrets: volume and environment variable,
- how to create secrets with command,
- how to get/delete secrets


### Steps

- Run minikube  (in this scenario, K8s runs on WSL2- Ubuntu 20.04) ("minikube start")

![image](https://user-images.githubusercontent.com/10358317/153183333-371fe598-d5a4-4b86-9b5d-9e33f35063cc.png)

- Create Yaml file (secret.yaml) in your directory and copy the below definition into the file:

``` 
# Secret Object Creation  
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
type: Opaque
stringData:
  db_server: db.example.com
  db_username: admin
  db_password: P@ssw0rd!
```

![image](https://user-images.githubusercontent.com/10358317/154717259-629e529e-4178-489e-8d20-bad22faeb782.png)

- Create Yaml file (secret-pods.yaml) in your directory and copy the below definition into the file:
- 3 Pods:
  - secret binding using volume
  - secret binding environment variable: 1. explicitly, 2. implicitly
  
```
apiVersion: v1
kind: Pod
metadata:
  name: secretvolumepod
spec:
  containers:
  - name: secretcontainer
    image: nginx
    volumeMounts:
    - name: secret-vol
      mountPath: /secret
  volumes:
  - name: secret-vol
    secret:
      secretName: mysecret
---
apiVersion: v1
kind: Pod
metadata:
  name: secretenvpod
spec:
  containers:
  - name: secretcontainer
    image: nginx
    env:
      - name: username
        valueFrom:
          secretKeyRef:
            name: mysecret
            key: db_username
      - name: password
        valueFrom:
          secretKeyRef:
            name: mysecret
            key: db_password
      - name: server
        valueFrom:
          secretKeyRef:
            name: mysecret
            key: db_server
---
apiVersion: v1
kind: Pod
metadata:
  name: secretenvallpod
spec:
  containers:
  - name: secretcontainer
    image: nginx
    envFrom:
    - secretRef:
        name: mysecret
```

![image](https://user-images.githubusercontent.com/10358317/154717520-554ae3b6-cb55-4ad6-a2f3-7669c0788f77.png)

![image](https://user-images.githubusercontent.com/10358317/154717625-d688251f-8bb6-44b4-843e-eca7b6496b29.png)

![image](https://user-images.githubusercontent.com/10358317/154717703-49d3e207-15c7-4f3e-afb6-ba712c4dea67.png)

- Create secret object:

![image](https://user-images.githubusercontent.com/10358317/153636591-40f14380-02f2-4bc4-98f9-5f9c6eb7b9a6.png)

- Create pods:

![image](https://user-images.githubusercontent.com/10358317/153636772-246179b9-01b9-4032-8b3c-bd16331f537f.png)

- Describe secret to see details:

![image](https://user-images.githubusercontent.com/10358317/153638070-edba4d19-8ece-4f93-9579-fa9546c4a15d.png)

- Run bash in the secretvolumepod (1st pod):

![image](https://user-images.githubusercontent.com/10358317/153637318-e42326e9-4dc3-490d-a787-b0f1251a1808.png)

- Run "printenv" command in the secretenvpod (2nd pod):

![image](https://user-images.githubusercontent.com/10358317/153637549-9a1ceb13-d2dd-49ce-931b-ccfefbb75595.png)

- Run "printenv" command in the secretenvallpod (3rd pod):

![image](https://user-images.githubusercontent.com/10358317/153637762-d6dff332-3d80-4558-80b5-2ae86f4d0c92.png)

- Create new secret with imperative way:

``` 
kubectl create secret generic mysecret2 --from-literal=db_server=db.example.com --from-literal=db_username=admin --from-literal=db_password=P@ssw0rd!
```   

![image](https://user-images.githubusercontent.com/10358317/153638556-50874231-7be3-4801-90d0-ae84f66c28e9.png)

- Create new secret using files (avoid to see in the history command list).
- Create file on the same directory before to run command (e.g. "touch server.txt"): 
  - server.txt    => put into "db.example.com" with "cat" command
  - password.txt  => put into "password" with "cat" command
  - username.txt  => put into "admin" with "cat" command

```     
kubectl create secret generic mysecret3 --from-file=db_server=server.txt --from-file=db_username=username.txt --from-file=db_password=password.txt
``` 

![image](https://user-images.githubusercontent.com/10358317/153639595-4f8e5c95-151c-4990-93ac-6e8b98776fbd.png)

- Create json file (config.json) and put following content
```
{
    "apiKey": "7ac4108d4b2212f2c30c71dfa279e1f77dd12356",
}
```

``` 
kubectl create secret generic mysecret4 --from-file=config.json
``` 

![image](https://user-images.githubusercontent.com/10358317/153640684-cb16dac0-cddd-40b0-a90f-9f42b28e3373.png)

- Delete mysecret4:

![image](https://user-images.githubusercontent.com/10358317/153640797-617ddd36-cbb6-4a73-8955-f4482e521dde.png)
