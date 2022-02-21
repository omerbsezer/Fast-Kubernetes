## LAB: K8s Cron Job

This scenario shows how K8s Cron job object works on minikube

### Steps

- Copy and save (below) as file on your PC (cronjob.yaml). 

```     
apiVersion: batch/v1
kind: CronJob
metadata:
  name: hello
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: hello
            image: busybox
            imagePullPolicy: IfNotPresent
            command:
            - /bin/sh
            - -c
            - date; echo Hello from the Kubernetes cluster
          restartPolicy: OnFailure
```

![image](https://user-images.githubusercontent.com/10358317/154947805-0c1db85f-fd52-4e3e-8e86-5afca73359ca.png)


- Create Cron Job:

![image](https://user-images.githubusercontent.com/10358317/152511636-b68caefa-1d1a-48a4-bc2b-a773e0ba5eef.png)

- Watch pods' status:

![image](https://user-images.githubusercontent.com/10358317/152511899-cb32ee77-b3b2-4cf5-ad44-f3b1187555f2.png)

- Watch job's status:

![image](https://user-images.githubusercontent.com/10358317/152511995-4a6ca576-99e1-4dbf-bf26-73c150a36b5b.png)

- Delete job: 

![image](https://user-images.githubusercontent.com/10358317/152512127-2410d92d-4555-45d7-ab3f-cac0d80839df.png)
