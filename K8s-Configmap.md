## LAB: K8s Configmap

This scenario shows:
- how to create config map (declerative way),
- how to use configmap: volume and environment variable,
- how to create configmap with command (imperative way),
- how to get/delete configmap


### Steps

- Run minikube  (in this scenario, K8s runs on WSL2- Ubuntu 20.04) ("minikube start")

![image](https://user-images.githubusercontent.com/10358317/153183333-371fe598-d5a4-4b86-9b5d-9e33f35063cc.png)

- Create Yaml file (config.yaml) in your directory and copy the below definition into the file:

``` 
apiVersion: v1
kind: ConfigMap
metadata:
  name: myconfigmap               
data:
  db_server: "db.example.com"        # configmap key-value parameters
  database: "mydatabase"
  site.settings: |
    color=blue
    padding:25px
---
apiVersion: v1
kind: Pod
metadata:
  name: configmappod
spec:
  containers:
  - name: configmapcontainer
    image: nginx
    env:                             # configmap using environment variable
      - name: DB_SERVER
        valueFrom:
          configMapKeyRef:           
            name: myconfigmap        # configmap name, from "myconfigmap" 
            key: db_server
      - name: DATABASE
        valueFrom:
          configMapKeyRef:
            name: myconfigmap
            key: database
    volumeMounts:
      - name: config-vol
        mountPath: "/config"
        readOnly: true
  volumes:
    - name: config-vol               # transfer configmap parameters using volume
      configMap:
        name: myconfigmap
```

![image](https://user-images.githubusercontent.com/10358317/154719668-bcd3bdb2-c102-489e-8049-747fd97126f3.png)

- Create configmap and the pod:

![image](https://user-images.githubusercontent.com/10358317/153645965-84f8fe93-e73e-4468-bce4-4d2c3f49546f.png)

- Run bash in the pod:

![image](https://user-images.githubusercontent.com/10358317/153647020-54a0cf44-582f-4aab-8375-18c9d82ca494.png)

- Define configmap with imperative way (--from-file and --from-literal) (create a file and put into "theme=dark")

```
kubectl create configmap myconfigmap2 --from-literal=background=red --from-file=theme.txt
```

![image](https://user-images.githubusercontent.com/10358317/153647730-cf7e1545-ffbf-4fe8-b87e-6f1b59ef71df.png)

- Delete configmap:

![image](https://user-images.githubusercontent.com/10358317/153647842-87c9b154-fb1e-40a4-893a-700a80c94161.png)
