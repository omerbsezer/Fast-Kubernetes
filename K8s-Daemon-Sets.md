## App: K8s Daemon Sets

This scenario shows how K8s Daemonsets work on minikube by adding new nodes

### Steps

- Copy and save (below) as file on your PC (daemonset.yaml). 

```     
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: logdaemonset
  labels:
    app: fluentd-logging
spec:
  selector:
    matchLabels:                                                 # label selector should be same labels in the template (template > metadata > labels)
      name: fluentd-elasticsearch
  template:
    metadata:
      labels:
        name: fluentd-elasticsearch
    spec:
      tolerations:
      - key: node-role.kubernetes.io/master                      # this toleration is to have the daemonset runnable on master nodes
        effect: NoSchedule                                       # remove it if your masters can't run pods  
      containers:
      - name: fluentd-elasticsearch
        image: quay.io/fluentd_elasticsearch/fluentd:v2.5.2      # installing fluentd elasticsearch on each nodes
        resources:
          limits:
            memory: 200Mi                                        # resource limitations configured           
          requests:
            cpu: 100m
            memory: 200Mi
        volumeMounts:                                            # definition of volumeMounts for each pod 
        - name: varlog
          mountPath: /var/log
        - name: varlibdockercontainers
          mountPath: /var/lib/docker/containers
          readOnly: true
      terminationGracePeriodSeconds: 30
      volumes:                                                   # ephemerial volumes on node (hostpath defined)   
      - name: varlog
        hostPath:
          path: /var/log
      - name: varlibdockercontainers
        hostPath:
          path: /var/lib/docker/containers    
```

- Create daemonset on minikube:

![image](https://user-images.githubusercontent.com/10358317/152146006-265e0595-cdf5-43c7-aea2-5437700323fd.png)

- Run watch command on Linux: "watch kubectl get daemonset", on Win: "kubectl get daemonset -w"

![image](https://user-images.githubusercontent.com/10358317/152146266-00d1f1b8-f2dc-495f-ab35-15e3d1629278.png)

- Add new node on the cluster:

![image](https://user-images.githubusercontent.com/10358317/152146458-14a66e8a-fcad-4a15-ac3e-6df1af4a43a4.png)

- To see, app runs automatically on the new node:

![image](https://user-images.githubusercontent.com/10358317/152147031-b934d393-8caf-49c3-ac4c-3b704f2d646a.png)

- Add new node (3rd):

![image](https://user-images.githubusercontent.com/10358317/152151984-ac8fd54c-676d-4be4-b2f1-4356613a8fed.png)

- Now daemonset have 3rd node:

![image](https://user-images.githubusercontent.com/10358317/152152156-c8cd559e-48dc-4ea3-85c9-6da7fbeb0794.png)

- Delete one of the pod:

![image](https://user-images.githubusercontent.com/10358317/152152437-7c883cd5-e809-4386-8832-362a612acf5f.png)

- Pod deletion can be seen here:

![image](https://user-images.githubusercontent.com/10358317/152152613-854c5340-c73b-4d72-bd08-951aa640d8ad.png)

- Daemonset create new pod automatically:

![image](https://user-images.githubusercontent.com/10358317/152152744-9f14751b-e214-4621-8208-1cb5437b6d71.png)

- See the nodes resource on dashboard:

![image](https://user-images.githubusercontent.com/10358317/152153072-5e53cd9c-42ba-4f50-85d8-c82ea1e39752.png)

- Delete nodes and delete daemonset:

![image](https://user-images.githubusercontent.com/10358317/152153355-b98bca05-87cd-46d2-a26d-eb614ca263ca.png)



