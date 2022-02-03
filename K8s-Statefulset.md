## App: K8s Stateful Set - Nginx

This scenario shows how K8s statefulset object works on minikube

### Steps

- Copy and save (below) as file on your PC (statefulset_nginx.yaml). 

```     
apiVersion: v1
kind: Service
metadata:
  name: nginx                                     # create a service with "nginx" name
  labels:
    app: nginx
spec:
  ports:
  - port: 80
    name: web                                     # create headless service if clusterIP:None
  clusterIP: None                                 # when requesting service name, service returns one of the IP of pods
  selector:                                       # headless service provides to reach pod with podName.serviceName
    app: nginx                                    # selects/binds to app:nginx (defined in: spec > template > metadata > labels > app:nginx)
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web                                       # statefulset name: web
spec:
  serviceName: nginx                              # binds/selects service (defined in metadata > name: nginx)            
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx                            
    spec:
      containers:
      - name: nginx
        image: k8s.gcr.io/nginx-slim:0.8
        ports:
        - containerPort: 80
          name: web
        volumeMounts:
        - name: www
          mountPath: /usr/share/nginx/html
  volumeClaimTemplates:
  - metadata:
      name: www
    spec:
      accessModes: [ "ReadWriteOnce" ]              # creates PVCs for each pod automatically
      resources:                                    # hence, each node has own PV
        requests:
          storage: 512Mi
```
- Create statefulset and pvc:

![image](https://user-images.githubusercontent.com/10358317/152322911-47e14c25-9f86-49ff-bdcf-df74e38e5939.png)

- Pods are created with statefulsetName-0,1,2 (e.g. web-0)

![image](https://user-images.githubusercontent.com/10358317/152323071-a79b5d15-22e4-424b-86a3-f84a77377b69.png)

- PVCs and PVs are automatically created for each pod. Even if pod is restarted again, same PV is bound to same pod.
 
![image](https://user-images.githubusercontent.com/10358317/152324124-bbae308a-533f-4476-8206-6d53c6b9b648.png)

- Scaled from 3 Pods to 4 Pods:

![image](https://user-images.githubusercontent.com/10358317/152324908-762100ca-94b3-4db4-b73e-9ad09c32588d.png)

- New pod's name is not assigned randomly, assigned in order and got "web-4" name. 

![image](https://user-images.githubusercontent.com/10358317/152325051-2f757f13-77ae-4aab-84d9-d6f6c8a04c1c.png)

- Scale down to 3 Pods again:

![image](https://user-images.githubusercontent.com/10358317/152325305-c10782a2-a8e2-4c5b-8da9-7ca90de9e00a.png)

- Last created pod is deleted: 

![image](https://user-images.githubusercontent.com/10358317/152325429-20d84fdf-aeb2-45e7-8790-55ba3a28b197.png)

- When creating headless service, service does not get any IP (e.g. None)

![image](https://user-images.githubusercontent.com/10358317/152325883-3b833268-cae9-4863-9e05-af80b0cefa8d.png)

- With headless service, service returns one of the IP, service balances the load between pods (loadbalacing between pods)

![image](https://user-images.githubusercontent.com/10358317/152327066-45cb6cf0-b988-48a7-aef7-2e8295334280.png)

- If we ping the specific pod with podName.serviceName (e.g. ping web-0.nginx), it returns the IP of the that pod.
- With statefulset, the name of the pod is known, this helps to ping pods with name of the pod.

![image](https://user-images.githubusercontent.com/10358317/152327651-449cb69b-fe2e-45a9-b0b1-bd01fa340eff.png)

