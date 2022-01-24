## App: K8s Liveness Probe

This scenario shows how the liveness probe works.

### Steps

- Create 3 Pods with following YAML file (pods.yaml):
  - In the first pod (e.g. web app), it sends HTTP Get Request to "http://localhost/healthz:8080" (port 8080)
    - If returns 400 > HTTP Code > 200, this Pod works correctly.
    - If returns HTTP Code > = 400, this Pod does not work properly.
    - initialDelaySeconds:3 => after 3 seconds, start liveness probe. 
    - periodSecond: 3 => Wait 3 seconds between each request.
  - In the second pod (e.g. console app), it controls whether a file ("healty") exists or not under specific directory ("/tmp/") with "cat" app. 
    - If returns 0 code, this Pod works correctly.
    - If returns different code except for 0 code, this Pod does not work properly.
    - initialDelaySeconds: 5 => after 5 seconds, start liveness probe. 
    - periodSecond: 5 => Wait 5 seconds between each request.
  - In the third pod (e.g. database app: mysql), it sends request over TCP Socket. 
    - If returns positive response, this Pod works correctly.
    - If returns negative response (e.g. connection refuse), this Pod does not work properly.
    - initialDelaySeconds: 15 => after 15 seconds, start liveness probe. 
    - periodSecond: 20 => Wait 20 seconds between each request.
```
apiVersion: v1
kind: Pod
metadata:
  labels:
    test: liveness
  name: liveness-http
spec:
  containers:
  - name: liveness
    image: k8s.gcr.io/liveness
    args:
    - /server
    livenessProbe:
      httpGet:
        path: /healthz
        port: 8080
        httpHeaders:
        - name: Custom-Header
          value: Awesome
      initialDelaySeconds: 3
      periodSeconds: 3
---
apiVersion: v1
kind: Pod
metadata:
  labels:
    test: liveness
  name: liveness-exec
spec:
  containers:
  - name: liveness
    image: k8s.gcr.io/busybox
    args:
    - /bin/sh
    - -c
    - touch /tmp/healthy; sleep 30; rm -rf /tmp/healthy; sleep 600
    livenessProbe:
      exec:
        command:
        - cat
        - /tmp/healthy
      initialDelaySeconds: 5
      periodSeconds: 5
---
apiVersion: v1
kind: Pod
metadata:
  name: goproxy
  labels:
    app: goproxy
spec:
  containers:
  - name: goproxy
    image: k8s.gcr.io/goproxy:0.1
    ports:
    - containerPort: 8080
    livenessProbe:
      tcpSocket:
        port: 8080
      initialDelaySeconds: 15
      periodSeconds: 20
 ```
 
- Run: "kubectl apply -f pods.yaml"
- On another terminal run: "kubectl get pods -w"
 ![image](https://user-images.githubusercontent.com/10358317/150846081-7e9142d1-b833-431f-82bc-a7385c73a875.png)
 
- Run to see details of liveness-http pod: "kubectl describe pod liveness-http"
![image](https://user-images.githubusercontent.com/10358317/150846456-5273b1f8-7043-4fa1-804c-77da74aca8de.png)
