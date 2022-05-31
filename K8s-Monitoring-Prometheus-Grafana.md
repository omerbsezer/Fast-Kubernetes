## LAB: K8s Monitoring: Prometheus and Grafana

This scenario shows how to implement Prometheus and Grafana on K8s Cluster


### Table of Contents
- [Monitoring With SSH](#ssh)
- [Monitoring With Prometheus and Grafana](#prometheus-grafana)
  - [Prometheus and Grafana for Windows](#windows)

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

- Monitoring all nodes' resources in terms of CPU, memory, disk space, network transmitted/received

![image](https://user-images.githubusercontent.com/10358317/171121847-88a7ee68-c38e-4fbd-ac72-30900e2c2e86.png)

![image](https://user-images.githubusercontent.com/10358317/171122247-d0e5a80c-0460-4ede-9e3a-8a15fa03b89b.png)


- Use nodeport option to make reachable with IP:Port. 
- Uninstall the current release run.

```
helm uninstall prometheus
```

- Open values.yaml file (kube-prometheus-stack/charts/grafana/values.yaml), change type from "ClusterIP" to "NodePort" and add "nodePort: 32333" 

![image](https://user-images.githubusercontent.com/10358317/171122676-59c04a9d-1170-42cb-8c84-d1de9e6c341e.png)

- Run the new release

```
helm install prometheus kube-prometheus-stack
```

- On the browser from any PC on the cluster, grafana screen can be viewed: MasterIP:32333

- Update (kube-prometheus-stack/charts/prometheus-node-exporter/values.yaml) to implement that node exporter works only on Linux machines. Add nodeSelector: kubernetes.io/os: linux

#### 2.1. Prometheus and Grafana for Windows <a name="windows"></a>

- Download windows_exporter-0.18.1-amd64.exe (latest version) from here: https://github.com/prometheus-community/windows_exporter/releases
- Copy/Move to under C:\ directory ("C:\windows_exporter-0.18.1-amd64.exe")
- Open Powershell with Admistration Rights, run:

```
New-Service -Name "windows_node_exporter" -BinaryPathName "C:\windows_exporter-0.18.1-amd64.exe"
Start-Service -Name windows_node_exporter
```
- Now, windows_exporter works as a service and runs automatically when restarting the windows node.  Check if it works in 2 ways: 
  - Open the browser and run: http://localhost:9182/metrics  to see resource data/metrics
  - Open Task Manager - Services Tab and see whether windows_node_exporter runs or not.

- Uninstall the current release run.

```
helm uninstall prometheus
```

- Open values.yaml in the kube-prometheus-stack directory (targets:  Windows IP, default port 9182)

```
    #additionalScrapeConfigs: [] (Line ~2480)
    additionalScrapeConfigs:
    - job_name: 'kubernetes-windows-exporter'
      static_configs:
        - targets: ["WindowsIP:9182"] 
```

- Run the new release

```
helm install prometheus kube-prometheus-stack
```

- Open Grafana and "Import"

![image](https://user-images.githubusercontent.com/10358317/171125351-f2560aff-f9cb-4929-9971-2d3c94c10891.png)

- Download Prometheus "Windows Exporter Node" dashboard from here: https://grafana.com/grafana/dashboards/14510/revisions
- There are  2 options: 
  - Copy the Json content and paste panel json,
  - Upload Json File

![image](https://user-images.githubusercontent.com/10358317/171125688-1df89d6f-ea85-4b13-bc0d-86934e6e4017.png)

- Select "Prometheus" as data source

- Now it works. Windows Node Exporter:

![image](https://user-images.githubusercontent.com/10358317/171122469-7b53a060-d778-463e-b215-cf8befb076b9.png)

## Reference

- https://youtu.be/jatcPHvChfI 
