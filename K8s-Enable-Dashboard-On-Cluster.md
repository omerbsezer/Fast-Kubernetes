## LAB: Enable Dashboard on Cluster


### K8s Cluster (with Multipass VM)
- K8s cluster was created before:
   - **Goto:** [K8s Kubeadm Cluster Setup](https://github.com/omerbsezer/Fast-Kubernetes/blob/main/K8s-Kubeadm-Cluster-Setup.md)

### Enable Dashboard on Cluster

- To enable dashboard on cluster, apply yaml file (https://github.com/kubernetes/dashboard)
```
kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended/kubernetes-dashboard.yaml
Kubectl proxy
on browser: http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
```

![image](https://user-images.githubusercontent.com/10358317/156365236-cda2797e-c786-41f4-b026-0a5779ebba5a.png)

- Now we should find to token to enter dashboard as admin user.

```
kubectl create serviceaccount dashboard-admin-sa
kubectl create clusterrolebinding dashboard-admin-sa --clusterrole=cluster-admin --serviceaccount=default:dashboard-admin-sa
kubectl get secrets
kubectl describe secret dashboard-admin-sa-token-m84l5             # token name change, pls find it using "kubectl get secrets"
```

![image](https://user-images.githubusercontent.com/10358317/156364438-8b3a192d-b36c-4b8d-8aaf-6387e707ac08.png)

![image](https://user-images.githubusercontent.com/10358317/156364553-e917899b-b918-4cdc-b87f-5f59f63c63f9.png)

![image](https://user-images.githubusercontent.com/10358317/156364657-25877a8c-827a-4d59-8332-eb4b05f09de0.png)

- Enter Token that is grabbed before: 

![image](https://user-images.githubusercontent.com/10358317/156364296-a213c2fe-ad04-4ba7-97d4-fea5046aa6cf.png)

- Now we reached the dashboard:

![image](https://user-images.githubusercontent.com/10358317/156365659-e6fc81a8-e5e4-4443-9ed3-3d839cc63842.png)

### Enable Dashboard on Minikube

- Minikube has addons to enable dashboard:

``` 
minikube addons enable dashboard
minikube addons enable metrics-server
minikube dashboard
# if running on WSL/WSL2 to open browser
sensible-browser http://127.0.0.1:45771/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/
```     
    
![image](https://user-images.githubusercontent.com/10358317/152148024-6ec65b33-9fd0-42eb-89c3-927e453553a2.png)

### Reference

- https://www.replex.io/blog/how-to-install-access-and-add-heapster-metrics-to-the-kubernetes-dashboard
- https://github.com/kubernetes/dashboard
