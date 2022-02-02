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

![image](https://user-images.githubusercontent.com/10358317/152146006-265e0595-cdf5-43c7-aea2-5437700323fd.png)

