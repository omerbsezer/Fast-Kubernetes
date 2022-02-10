## App: K8s Multicontainer - Sidecar - Volume - Port-Forward 

This scenario shows:
- how to create multicontainer in one pod,
- how the multicontainers in the same pod have same ethernet interface (IPs),
- how the multicontainers in the same pod can reach the shared volume area,
- how to make port-forwarding to host PC ports

### Steps

- Run minikube  (in this scenario, K8s runs on WSL2- Ubuntu 20.04) ("minikube start")

  ![image](https://user-images.githubusercontent.com/10358317/153183333-371fe598-d5a4-4b86-9b5d-9e33f35063cc.png)
  
- Create Yaml file (multicontainer.yaml) in your directory and copy the below definition into the file:

```
apiVersion: v1
kind: Pod
metadata:
  name: multicontainer
spec:
  containers:
  - name: webcontainer                           # container name: webcontainer
    image: nginx                                 # image from nginx
    ports:                                       # opening-port: 80
      - containerPort: 80
    volumeMounts:
    - name: sharedvolume                          
      mountPath: /usr/share/nginx/html          # path in the container
  - name: sidecarcontainer
    image: busybox                              # sidecar, second container image is busybox
    command: ["/bin/sh"]                        # it pulls index.html file from github every 15 seconds
    args: ["-c", "while true; do wget -O /var/log/index.html https://raw.githubusercontent.com/omerbsezer/Fast-Kubernetes/main/index.html; sleep 15; done"]
    volumeMounts:
    - name: sharedvolume
      mountPath: /var/log
  volumes:                                      # define emptydir temporary volume, when the pod is deleted, volume also deleted
  - name: sharedvolume                          # name of volume 
    emptyDir: {}                                # volume type emtpydir: creates empty directory where the pod is runnning
```

- Create multicontainer on the pod (webcontainer and sidecarcontainer):

![image](https://user-images.githubusercontent.com/10358317/153407239-c74aa02d-dc51-4ce3-a680-ec777db8477b.png)

- Connect (/bin/sh of the webcontainer) and install net-tools to show ethernet interface (IP: 172.17.0.3) 

![image](https://user-images.githubusercontent.com/10358317/153408261-bdd4b6b5-c44f-4a12-9959-85cb9c582178.png)

- Connect (/bin/sh of the sidecarcontainer) and show ethernet interface (IP: 172.17.0.3). 
- Containers running on same pod have same ethernet interfaces and same IPs (172.17.0.3).

![image](https://user-images.githubusercontent.com/10358317/153408722-d01eff1c-64e9-4020-a556-9d44a7a0a4f8.png)

- Under the webcontainer, the shared volume with sidecarcontainer can be reachable: 
 
![image](https://user-images.githubusercontent.com/10358317/153412202-bfb7533a-1960-4436-b10b-69f4d788a4ae.png)

- It can be seen from sidecarcontainer. Both of the container can reach same volume area.
- If the new file is created on this volume, other container can also reach same new file. 

![image](https://user-images.githubusercontent.com/10358317/153412522-9214cf3c-d529-4381-b668-a8ad84f95ad5.png)

- When we look at the sidecarcontainer logs, it pulls index.html file from "https://raw.githubusercontent.com/omerbsezer/Fast-Kubernetes/main/index.html" every 15 seconds.

![image](https://user-images.githubusercontent.com/10358317/153412851-3f9763b8-9cfe-4822-b869-b2333f580e77.png)

- We can forward the port of the pod to the host PC port (hostPort:containerPort, e.g: 8080:80):

![image](https://user-images.githubusercontent.com/10358317/153413173-55554d77-2531-4fbe-88e2-1e84ded64be7.png)

- On the browser, goto http://127.0.0.1:8080/

![image](https://user-images.githubusercontent.com/10358317/153413389-f5eec26e-b2cd-44f9-a968-e6133550bfc6.png)


- After updating the content of the index.html, new html page will be downloaded by the sidecarcontainer:

![image](https://user-images.githubusercontent.com/10358317/153414407-3caf71b0-1286-42e8-87e4-d7d1ba47c356.png)

- Exit from the container shell and delete multicontainer in a one pod:

![image](https://user-images.githubusercontent.com/10358317/153416457-65d792fb-62f2-4015-aefd-8f7305379f23.png)
