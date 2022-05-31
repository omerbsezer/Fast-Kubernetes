## LAB: K8s Monitoring: Prometheus and Grafana

This scenario shows how to implement Prometheus and Grafana on K8s Cluster


### Table of Contents
- [Monitoring With SSH](#ssh)
- [Monitoring With Prometheus and Grafana](#prometheus-grafana)

There are different options to monitor K8s cluster: SSH, Kubernetes Dashboard, Prometheus and Grafana, etc.
  
## 1. Monitoring With SSH <a name="ssh"></a>

- SSH can be used to get basic information about the cluster, nodes, and pods.
- Make SSH connection to Master Node of the K8s Cluster

``` 
ssh username@masterIP
```

- To get the nodes of the K8s

``` 
kubectl get nodes -o wide
```

- To get the pods on the K8s Cluster

```
kubectl get pods -o wide
```

- For Linux PCs: To get the pods on the K8s Cluster in real-time with the "watch" command

``` 
watch kubectl get pods -o wide
```

- To get all K8s objects:

```
kubectl get all
```

## 2. Monitoring With Prometheus and Grafana <a name="prometheus-grafana"></a>

- While implementting Prometheus and Grafana, Helm is used. 
- To add Prometheus repo into local repo and download it:

```
mkdir helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm pull  prometheus-community/kube-prometheus-stack
tar zxvf kube-prometheus-stack-34.10.0.tgz
cd kube-prometheus-stack
```

- "Values.yaml" file can be viewed and updated according to new values and new configuration.
- To install prometheus, release name is prometheus 

```
helm install prometheus kube-prometheus-stack
```

- Port forwarding is needed on the default connection, run on the different terminals: 

```
kubectl port-forward deployment/prometheus-grafana 3000
kubectl port-forward prometheus-prometheus-kube-prometheus-prometheus-0 9090
```

- Default provided username: admin, password: prom-operator

![image](https://user-images.githubusercontent.com/10358317/171119775-74e42538-afde-4cad-ac3b-01bd00b434f5.png)



### Reference

- https://youtu.be/jatcPHvChfI 
