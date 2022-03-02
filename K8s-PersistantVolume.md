## LAB: K8s Persistent Volumes and Persistent Volume Claims

This scenario shows how K8s PVC and PV work on minikube

### Steps

- On Minikube, we do not have to reach NFS Server. So we simulate NFS Server with Docker Container.

``` 
docker volume create nfsvol
docker network create --driver=bridge --subnet=10.255.255.0/24 --ip-range=10.255.255.0/24 --gateway=10.255.255.10 nfsnet
docker run -dit --privileged --restart unless-stopped -e SHARED_DIRECTORY=/data -v nfsvol:/data --network nfsnet -p 2049:2049 --name nfssrv ozgurozturknet/nfs:latest
``` 

![image](https://user-images.githubusercontent.com/10358317/152173180-47015aa9-a8b8-4a41-a49e-9154a4eb26e2.png)

- Now our simulated server enabled.
- Copy and save (below) as file on your PC (pv.yaml). 

```     
apiVersion: v1                               
kind: PersistentVolume
metadata:
   name: mysqlpv
   labels:
     app: mysql                                # labelled PV with "mysql"
spec:
  capacity:
    storage: 5Gi                               # 5Gibibyte = power of 2; 5GB= power of 10
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain      
  nfs:
    path: /                                    # binds the path on the NFS Server
    server: 10.255.255.10                      # IP of NFS Server
```

![image](https://user-images.githubusercontent.com/10358317/154735518-3bde3e54-518b-4fba-bdf5-bd57eabd2546.png)

- Create PV object on our cluster:

![image](https://user-images.githubusercontent.com/10358317/152173879-837bb03a-fd9f-44ba-becc-fa3ab7ae748f.png)

- Copy and save (below) as file on your PC (pvc.yaml). 

```     
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysqlclaim
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem          
  resources:
    requests:
      storage: 5Gi
  storageClassName: ""
  selector:
    matchLabels:
      app: mysql                     # chose/select "mysql" PV that is defined above.
```

![image](https://user-images.githubusercontent.com/10358317/154735540-3026d9de-92bd-4e9d-a00a-3f0cf597db34.png)

- Create PVC object on our cluster. After creation, PVC's status shows to bind to PV ("Bound"):

![image](https://user-images.githubusercontent.com/10358317/152174156-9d20270f-3be7-46b1-ac07-2c32c56036c4.png)

- Copy and save (below) as file on your PC (deploy.yaml). 

```     
apiVersion: v1                                     # Create Secret object for password
kind: Secret
metadata:
  name: mysqlsecret
type: Opaque
stringData:
  password: P@ssw0rd!
---
apiVersion: apps/v1
kind: Deployment                                  # Deployment
metadata:
  name: mysqldeployment
  labels:
    app: mysql
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql                                   # select deployment container (template > metadata > labels)
  strategy:
    type: Recreate
  template:
    metadata:
      labels:  
        app: mysql
    spec:
      containers:
        - name: mysql
          image: mysql
          ports:
            - containerPort: 3306
          volumeMounts:                             # VolumeMounts on path and volume name
            - mountPath: "/var/lib/mysql"
              name: mysqlvolume                     # which volume to select (volumes > name)
          env:
            - name: MYSQL_ROOT_PASSWORD
              valueFrom:                            # get mysql password from secrets
                secretKeyRef:
                  name: mysqlsecret
                  key: password
      volumes:
        - name: mysqlvolume                         # name of Volume
          persistentVolumeClaim:
            claimName: mysqlclaim                   # chose/select "mysqlclaim" PVC that is defined above.
```

![image](https://user-images.githubusercontent.com/10358317/154735894-bb807908-5378-487c-bb67-8e68ab26cc00.png)

- Run deployment on our cluster:

![image](https://user-images.githubusercontent.com/10358317/152175581-ccaafe14-e41d-4a14-8e4f-cde96e9bf31b.png)

- Watching deployment status:
 
 ![image](https://user-images.githubusercontent.com/10358317/152175839-0b3c4cbd-210a-46ff-80ac-8dbd723c6a62.png)

- See the details of pod (mounts and volumes):

![image](https://user-images.githubusercontent.com/10358317/152176550-73e8c06c-0f5a-42ed-ab06-171e545ee078.png)

- Enter into the pod and see the path that the volume is mounted ("kubectl exec -it <PodName> -- bash"):

![image](https://user-images.githubusercontent.com/10358317/152181824-96dfbc72-ee0f-45c0-b896-b6fea7b9f7a5.png)

- If the new node is added into the cluster and this running pod is stopped running on the main minikube node, the pod will start on the another node.
- With this scenario, we can see the followings:
   - Deployment always run pod on the cluster.
   - The pod which is created on the new node still connects the persistent volume (there is not any loss for volume)
   - How assigning taint on the node (key:=value:NoExecute, if NoExecute is not tolerated by pod, pod is deleted on the node)

![image](https://user-images.githubusercontent.com/10358317/152178562-388f60db-977e-4247-8b0f-2ff9e0df602e.png)

- New pod is created on the new node (2nd node)

![image](https://user-images.githubusercontent.com/10358317/152178713-ca502e6c-140e-4471-aa37-dc4a8c5c6785.png)

- Second pod also is connected to the same volume again.

![image](https://user-images.githubusercontent.com/10358317/152179192-d6030535-8a54-451a-b97a-319ba2549870.png)
   
- Enter into the 2nd pod and see the path that the volume is mounted ("kubectl exec -it <PodName> -- bash"). When you see the files at the same path on the 2nd pod, volume files are same:
   
![image](https://user-images.githubusercontent.com/10358317/152182472-e67f7162-a4cf-4034-aa98-375860fbd38d.png)
  
- Delete minikube, docker container, volume, network:

![image](https://user-images.githubusercontent.com/10358317/152180006-911adcbc-0d5a-4d6d-9364-eb7fe1bca0d2.png)

### References
- https://github.com/aytitech/k8sfundamentals/tree/main/pvpvc
