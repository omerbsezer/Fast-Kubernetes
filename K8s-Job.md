## LAB: K8s Job

This scenario shows how K8s job object works on minikube

### Steps

- Copy and save (below) as file on your PC (job.yaml).
- File: https://github.com/omerbsezer/Fast-Kubernetes/blob/main/labs/job/job.yaml 

```     
apiVersion: batch/v1
kind: Job
metadata:
  name: pi
spec:
  parallelism: 2               # each step how many pods start in parallel at a time
  completions: 10              # number of pods that run and complete job at the end of the time
  backoffLimit: 5              # to tolerate fail number of job, after 5 times of failure, not try to continue job, fail the job
  activeDeadlineSeconds: 100   # if this job is not completed in 100 seconds, fail the job
  template:
    spec:
      containers:
      - name: pi
        image: perl           # image is perl from docker   
        command: ["perl",  "-Mbignum=bpi", "-wle", "print bpi(2000)"]    # it calculates the first 2000 digits of pi number
      restartPolicy: Never   
```

![image](https://user-images.githubusercontent.com/10358317/154946885-80e87f3c-5120-4c09-bde2-a35cd09a7383.png)

- Create job:

![image](https://user-images.githubusercontent.com/10358317/152507949-922134f4-28cb-4d4f-8ccf-d5c5657b79c3.png)

- Watch pods' status:

![image](https://user-images.githubusercontent.com/10358317/152507888-21b8de27-c4a4-4772-8209-072bdcd66ad5.png)

- Watch job's status:

![image](https://user-images.githubusercontent.com/10358317/152508221-1795ed68-083b-4e23-b0e5-8c97a0672141.png)

- After pods' completion, we can see the logs of each pods. Pods are not deleted after the completion of task on each pod. 

![image](https://user-images.githubusercontent.com/10358317/152508363-a61e5c7a-57fa-4030-a8b0-d9baed027146.png)

- Delete job: 

![image](https://user-images.githubusercontent.com/10358317/152508749-049880e4-96b5-4dfd-96c2-107796366c02.png)
