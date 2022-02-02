## App: K8s Persistant Volume and Persistant Volume Claim

This scenario shows how K8s PVC and PV work on minikube

### Steps

- On Minikube, we do not have to reach NFS Server. So we simulate NFS Server with Docker Container.


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
      app: mysql
```

- Copy and save (below) as file on your PC (deploy.yaml). 

```     
apiVersion: v1
kind: Secret
metadata:
  name: mysqlsecret
type: Opaque
stringData:
  password: P@ssw0rd!
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysqldeployment
  labels:
    app: mysql
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
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
          volumeMounts:
            - mountPath: "/var/lib/mysql"
              name: mysqlvolume
          env:
            - name: MYSQL_ROOT_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mysqlsecret
                  key: password
      volumes:
        - name: mysqlvolume
          persistentVolumeClaim:
            claimName: mysqlclaim
```


