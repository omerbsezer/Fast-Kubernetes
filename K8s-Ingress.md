## App: K8s Ingress

This scenario shows how K8s ingress works on minikube

### Steps

- Run minikube on Windows Hyperv or Virtualbox. In this scenario:

``` 
minikube start --driver=hyperv 
or
minikube start --driver=hyperv --force-systemd
```  

- To install ingress controller on K8s cluster, please visit to learn: https://kubernetes.github.io/ingress-nginx/deploy/

- On Minikube, it is only needed to enable ingress controller.

``` 
minikube addons enable ingress
minikube addons list
``` 

![image](https://user-images.githubusercontent.com/10358317/152980050-9f59638e-22d2-4581-a045-0c4199cb0be1.png)

- Copy and save (below) as file on your PC (appingress.yaml). 

```     
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: appingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$1
spec:
  rules:
    - host: webapp.com
      http:
        paths:
          - path: /blue
            pathType: Prefix
            backend:
              service:
                name: bluesvc
                port:
                  number: 80
          - path: /green
            pathType: Prefix
            backend:
              service:
                name: greensvc
                port:
                  number: 80
    - host: todoapp.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: todosvc
                port:
                  number: 80
```

- Copy and save (below) as file on your PC (deploy.yaml). 

```     
apiVersion: apps/v1
kind: Deployment
metadata:
  name: blueapp
  labels:
    app: blue
spec:
  replicas: 2
  selector:
    matchLabels:
      app: blue
  template:
    metadata:
      labels:
        app: blue
    spec:
      containers:
      - name: blueapp
        image: ozgurozturknet/k8s:blue
        ports:
        - containerPort: 80
        livenessProbe:
          httpGet:
            path: /healthcheck
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
        readinessProbe:
          httpGet:
            path: /ready
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 3
---
apiVersion: v1
kind: Service
metadata:
  name: bluesvc
spec:
  selector:
    app: blue
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: greenapp
  labels:
    app: green
spec:
  replicas: 2
  selector:
    matchLabels:
      app: green
  template:
    metadata:
      labels:
        app: green
    spec:
      containers:
      - name: greenapp
        image: ozgurozturknet/k8s:green
        ports:
        - containerPort: 80
        livenessProbe:
          httpGet:
            path: /healthcheck
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
        readinessProbe:
          httpGet:
            path: /ready
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 3
---
apiVersion: v1
kind: Service
metadata:
  name: greensvc
spec:
  selector:
    app: green
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: todoapp
  labels:
    app: todo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: todo
  template:
    metadata:
      labels:
        app: todo
    spec:
      containers:
      - name: todoapp
        image: ozgurozturknet/samplewebapp:latest
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: todosvc
spec:
  selector:
    app: todo
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

- Run "deploy.yaml" and "appingress.yaml" to create deployments and services

![image](https://user-images.githubusercontent.com/10358317/152981672-06a18f3a-4d9c-4960-8c2e-1fd931d8ad11.png)

- Add url-ip on Windows/System32/Drivers/etc/hosts file: 

![image](https://user-images.githubusercontent.com/10358317/152983054-66993f34-0d4b-4381-8ae6-ec8441cb6366.png)

- When running on browser, "webapp.com/blue":

![image](https://user-images.githubusercontent.com/10358317/152982739-c86fac86-c0d6-465b-bc4e-391d4e56eb9f.png)

- When running on browser, "webapp.com/green":

![image](https://user-images.githubusercontent.com/10358317/152983147-057503d0-d2f1-45a2-bc35-0117676a2abb.png)

- When running on browser, "todoapp.com":

![image](https://user-images.githubusercontent.com/10358317/152983854-c35588c1-170a-4d02-9573-0e712876bad2.png)


### References
