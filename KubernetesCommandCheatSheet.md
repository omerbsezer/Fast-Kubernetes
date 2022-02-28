## Kubernetes Commands Cheatsheet

#### minikube command
```
minikube start
minikube status
kubectl get nodes
minikube stop #does not delete, it runs with start
minikube delete # delete all
```
#### kubeadm command
- Kubeadm provides K8s cluster on on-premise
- You can test Kubeadm on PlayWithKubernetes
- Creating cluster with 1 master, 2 nodes (add new instance) on PlayWithKubernetes
```
on master: kubeadm init --apiserver-advertise-address $(hostname -i) --pod-network-cidr 10.5.0.0/16
on nodes: kubeadm join 192.168.0.13:6443 --token ge5xcq.xh2mcb4rqa8lz0db \
    --discovery-token-ca-cert-hash sha256:a3ba7ced9383a5b5704b6fbf696f243a8322759b68b9d07b747b174fcc838540
on master: mkdir -p $HOME/.kube
on master: cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
on master: chown $(id -u):$(id -g) $HOME/.kube/config
on master: kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yaml
kubectl get nodes
kubectl run test --image=nginx --restart=Never
```

#### kubectl config: context, user, cluster
```
kubectl config
kubectl config get-contexts  #get all context
kubectl config current-context  #get context
kubectl config use-context docker-desktop  #change context
kubectl config use-context docker-desktop
kubectl config use-context aks-k8s-test  
kubectl config use-context default  # default=minikube 
kubectl get nodes
```

#### cluster-info
```
kubectl cluster-info
kubectl cp --help
kubectl [verb] [type] [object]
kubectl delete pods test_pod
kubectl [get|delete|edit|apply] [pods, deployment, services, etc.] [podName, serviceName, deploymentName, etc.]
```

#### namespace, -n 
```
kubectl get pods # default namespace
kubectl get pods -n kube-system  #list kube-system namespace pods.
kubectl get pods --all-namespaces
kubectl get pods -A # all-namespace
```

#### more info about pods
```
kubectl get pods -A   # all-namespace
kubectl get pods -A -o wide # all-namespace with more detailed
kubectl get pods -A -o yaml
kubectl get pods -A -o json
kubectl get pods -A -o go-template
kubectl get pods -A -o json | jq -r ".items[].spec.containers[].name"   #jq parser query 
```

#### commands help
- 'help' to learn more for commands
```
kubectl apply --help #explain command
kubectl delete --help
```

#### object help: with explain
- 'explain' to learn more for objects 
```
kubectl explain pod
kubectl explain deployment
```

#### pod ~ container
```
kubectl run firstpod --image=nginx --restart=Never
kubectl run secondpod --image=nginx --port=80 --labels=app=frontend --restart=Never
```

#### get info about pods
```
kubectl get pods -o wide
kubectl describe pods firstpod
```

#### show log 
```
kubectl logs firstpod
kubectl logs -f firstpod  #watch live log with -f
```

#### run command in pod
```
kubectl exec firstpod -- hostname  #hostname command run in pod 
kubectl exec firstpod -- ls / #list command run in pod 
```

#### connect container in the pod
```
kubectl exec -it firstpod -- /bin/sh  # open shell, connect container
kubectl exec -it firstpod -- bash # run bash 
```

#### delete pod
```
kubectl delete pods firstpod
```

#### learn/explain api of objects
```
kubectl explain pods
kubectl explain deployments
kubectl explain serviceaccount
```

#### Declerative way with file, Imperative way with command
- File contents:
  - apiVersion: 
  - kind: (pod, deployment, etc.)
  - metadata: (podName, label, etc.)
  - specs: (restartPolicy, container name, image, command, ports, etc.)

#### file apply for declerative 
```
kubectl apply -f pod1.yaml
```

#### edit 
```
kubectl edit pods firstpod
```

#### delete 
```
kubectl delete -f podlabel.yaml #all related objects deleted with declerative way
```

#### watch pods always
```
kubectl get pods -w
```

#### run multiple container on 1 pod, -c containerName
```
kubectl exec -it multicontainer -c webcontainer -- /bin/sh  # -c ile containername, if more than one container
kubectl exec -it multicontainer -c sidecarcontainer -- /bin/sh 
kubectl logs -f multicontainer -c sidecarcontainer
```

#### port-forward to pod
```
kubectl port-forward pod/multicontainer 80:80   ## host:container port, if command is not run, port is not opened
kubectl port-forward pod/multicontainer 8080:80  # when browsing 127.0.0.1:8080, host:8080 goes to pod:80 and directs traffic.
kubectl port-forward <pod-name> <locahost-port>:<pod-port>
kubectl port-forward deployment/mydeployment 5000 6000  # Listen on ports 5000 and 6000 locally, forwarding data to/from ports 5000 and 6000 in a pod selected by the deployment
kubectl port-forward service/myservice 5000 6000 # Listen on ports 5000 and 6000 locally, forwarding data to/from ports 5000 and 6000 in a pod selected by the service
kubectl port-forward --address localhost,10.19.21.23 pod/mypod 8888:5000 # Listen on port 8888 on localhost and selected IP, forwarding to 5000 in the pod
kubectl port-forward pod/mypod :5000 # Listen on a random port locally, forwarding to 5000 in the pod
kubectl port-forward --address 0.0.0.0 pod/mypod 8888:5000  # Listen on port 8888 on all addresses, forwarding to 5000 in the pod
```

#### label ve selector
```
kubectl get pods -l "app" --show-labels  #with -l, search label 
kubectl get pods -l "app=firstapp" --show-labels 
kubectl get pods -l "app=firstapp,tier=frontend" --show-labels
kubectl get pods -l "app in (firstapp)" --show-labels
kubectl get pods -l "!app" --show-labels  #list not app key
kubectl get pods -l "app notin (firstapp)" --show-labels  #inverse
kubectl get pods -l "app in (firstapp,secondapp)" --show-labels  #or 
kubectl get pods -l "app=firstapp,app=secondapp)" --show-labels  #and 
```

#### label addition
```
command (imperative): kubectl label pods pod9 app=thirdapp
command (imperative): kubectl label pods pod9 app-
kubectl label --overwrite pods pod9 team=team3   #overwrite
kubectl label pods --all foo=bar   # all pods, label addition
```

#### label node
- Node could be labelled (e.g. nodes have gpu, ssd, can be labelled)
```
kubectl label nodes minikube hddtype=ssd 
```

#### annotation
```
kubectl annotate pods annotationpod foo=bar ##annotate add
kubectl annotate pods annotationpod foo- ##annotate delete
```

#### namespace: object
```
kubectl get namespaces  
kubectl get pods #defaulttaki podlar
kubectl get pods --namespace kube-system #only kube-system
kubectl get pods -n kube-system #only kube-system
kubectl get pods --all-namespaces #all namespaces
kubectl get pods -A #all namespaces
kubectl exec -it namespacepod -n development -- /bin/sh #run terminal to add namespace
kubectl config set-context --current --namespace=development
kubectl config set-context --current --namespace=default
kubectl delete namespaces development
```

#### DEPLOYMENT: run more than 1 pod and synch
```
kubectl create deployment firstdeployment --image=nginx:latest --replicas=2
kubectl get deployment -w #always watch
kubectl get deployment
kubectl delete pods firstdeployment-pod 
kubectl set image deployment/firstdeployment nginx=httpd  # update containers on deployment
kubectl scale deployment firstdeployment --replicas=5  # manuel scale, increase/decrease replicas
kubectl delete deployment firstdeployment  # delete deployment
```

#### Deployment from file
- There should be at least one entry for spec/selector for each deployment to choose pod
- There should be same entries for template/metadata/labels/app and spec/selector/matchLabels/app for deployment-pod match
```
kubectl apply -f deploymenttemplate.yaml
```

#### rollout
```
kubectl rollout undo deployment firstdeployment # undo
```
  
#### record: save, return to desired revision
```
kubectl apply -f deployrolling.yaml --record
kubectl edit deployment rolldeployment --record 
kubectl set image deployment rolldeployment nginx=httpd:alpine --record=true 
kubectl rollout history deployment rolldeployment                  # show record history 
kubectl rollout history deployment rolldeployment --revision=2     # show 2.revision history
kubectl rollout undo deployment rolldeployment --to-revision=1     # roll to the first revision
```

#### live rollout commands logs on different terminal 
```
kubectl apply -f deployrolling.yaml
on another terminal: kubectl rollout status deployment rolldeployment -w 
kubectl rollout pause deployment rolldeployment   # pause the current deployment rollout/update
kubectl rollout resume deployment rolldeployment  # resume the current deployment rollout/update
```

#### service
- Service, --service-cluster-ip-range "10.100.0.0/16"
- 4 type Service object:
  - ClusterIP: direct traffic on the cluster
  - NodePort: node can be reachable from outside
  - LoadBalancer: load balancing
  - ExternalName
```
kubectl apply -f serviceClusterIP.yaml
kubectl get service -o wide
```
	  
#### service with command
```
kubectl expose deployment backend --type=ClusterIP --name=backend   #clusterIP type service creation
kubectl get service
kubectl expose deployment frontend --type=NodePort --name=frontend  #ndePort type service creation
kubectl get service 
```

#### service-endpoints
```
kubectl get endpoints                 # same endpoints created with services
kubectl describe endpoints frontend   # show ip adresses
kubectl delete pods frontend-xx-xx    # when pod deleted, ip also deleted 
kubectl scale deployment frontend --replicas=5    # new ip added
kubectl scale deployment frontend --replicas=2    
```

#### environment variables
```
spec:
  containers:
  - name: envpod
    image: ozgurozturknet/env:latest
    ports:
    - containerPort: 80
    env:
      - name: USER
        value: "Ozgur"
      - name: database
        value: "testdb.example.com"
```
```
kubectl apply -f podenv.yaml
kubectl get pods
kubectl exec envpod --  printenv  ## env. variable
kubectl exec -it firstpod -- /bin/sh
kubectl port-forward pod/envpod 8080:80  #port forwarding
kubectl delete -f podenv.yaml
```

#### volume
- ephemeral volume (temporary volume): it can be reachable from more than 1 container in the pod. When pod is deleted, volume is also deleted like cache.
- 2 types of ephmeral volume: 
 - 1.emptydir (create empty directory on the node, this volume is mounted on the container)
 - 2.hostpath: worker node (worker PC) with file path, more than one file or directory can be connected

##### emptydir volume:
```
  volumes:
  - name: cache-vol
    emptyDir: {}
```
	
##### container mount:
```
  - name: sidecar
    image: busybox
    command: ["/bin/sh"]
    args: ["-c", "sleep 3600"]
    volumeMounts:
    - name: cache-vol
      mountPath: /tmp/log
```
```
kubectl apply -f podvolumeemptydir.yaml
kubectl get pods -w
kubectl exec -it emptydir -c frontend -- bash
kubectl exec emptydir -c frontend -- rm -rf healthcheck #heltcheck siliniyor, container restart ediliyor.
```

##### hostpath type:
```
   containers:
    volumeMounts:
    - name: directory-vol
      mountPath: /dir1 (on container /dir1)
    - name: dircreate-vol
      mountPath: /cache (on container /cache)
    - name: file-vol
      mountPath: /cache/config.json     
	  
  volumes:
  - name: directory-vol
    hostPath:
      path: /tmp  (worker node /tmp directory, create Directory type volume)
      type: Directory 
  - name: dircreate-vol
    hostPath:
      path: /cache (worker node /cache directory, create DirectoryOrCreate type volume)
      type: DirectoryOrCreate
  - name: file-vol
    hostPath:
      path: /cache/config.json
      type: FileOrCreate
```
```
kubectl apply -f podvolumehostpath.yaml
kubectl exec -it hostpath -c hostpathcontainer -- bash
```


#### secret: declerative way
```
kubectl apply -f secret.yaml
kubectl get secrets
kubectl describe secret mysecret
```

#### secret: imperative (cmd)
```
kubectl create secret generic mysecret2 --from-literal=db_server=db.example.com --from-literal=db_username=admin --from-literal=db_password=P@ssw0rd!
kubectl create secret generic mysecret4 --from-file=config.json  #create config.json that inludes pass and username.
```

#### taint and toleration 
```
kubectl describe nodes minikube
kubectl taint node minikube platform=production:NoSchedule  #taint add
kubectl taint node minikube platform-   # taint delete
```

#### connect pod with bash and apt install
```
kubectl exec -it PodName -- bash
apt update
apt install net-tools
apt install iputils-ping
ifconfig
ping x.x.x.x
```

