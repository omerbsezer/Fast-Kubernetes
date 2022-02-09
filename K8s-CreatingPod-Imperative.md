## App: K8s Creating Pod - Imperative Way

This scenario shows:
- how to create basic K8s pod using imperative commands,
- how to get more information about pod (to solve troubleshooting),
- how to run commands in pod,
- how to delete pod. 



### Steps

- Run minikube  (in this scenario, K8s runs on WSL2- Ubuntu 20.04)

  ![image](https://user-images.githubusercontent.com/10358317/153183333-371fe598-d5a4-4b86-9b5d-9e33f35063cc.png)

- Run pod in imperative way
  - "kubectl run <podName> --image=<imageName>"
  - "kubectl get pods -o wide" : get info about pods

  ![image](https://user-images.githubusercontent.com/10358317/153183932-f8cd1547-3b10-47af-be3a-a1aedbfcf4ad.png)

- Describe pod to get mor information about pods (when encountered troubleshooting):
  
  ![image](https://user-images.githubusercontent.com/10358317/153184743-b0617841-db71-4c02-8d7b-c0054d9249bd.png)
  
- To reach logs in the pod (when encountered troubleshooting):
  
  ![image](https://user-images.githubusercontent.com/10358317/153185140-e7c2a4e3-29d0-4636-9586-62eec358c6bb.png)

- To reach logs in the pod 2ith "-f" (LIVE Logs, attach to the pod's log):
  
  ![image](https://user-images.githubusercontent.com/10358317/153185353-1969fe8c-e166-492e-b55d-2d96cedf3709.png)
  
 - Run command on pod ("kubectl exec <podName> -- <command>"):
  
   ![image](https://user-images.githubusercontent.com/10358317/153185867-fbe27ddb-619d-4d3e-bbce-3f021c073ad8.png)
  
  - Entering into the pod and running bash or sh on pod:
    - "kubectl exec -it <podName> -- bash"
    - "kubectl exec -it <podName> -- /bins/sh"
    - exit from pods 2 ways:
      - "exit" command
      - "CTRL+P+Q"
 
    ![image](https://user-images.githubusercontent.com/10358317/153186349-4dff117c-66ca-46a9-8030-2bdf27e6e0bb.png)
  
- Delete pod:
  
  ![image](https://user-images.githubusercontent.com/10358317/153187052-d3b12b0d-85cb-4885-afa9-9a7904dc964b.png)

- Imperative way could be difficult to store and manage process. Every time we have to enter commands. To prevent this, we can use YAML file to define pods and pods' feature. This way is called Declerative Way.
  
