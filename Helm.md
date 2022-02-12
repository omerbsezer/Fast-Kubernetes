## Helm

### Helm Install
- Installed on Ubuntu 20.04 (for other platforms: https://helm.sh/docs/intro/install/)

```
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```
- Check version (helm version):

![image](https://user-images.githubusercontent.com/10358317/153708424-d875f4bc-1af5-4169-85af-c87044e64f17.png)

- **ArtifactHUB:** https://artifacthub.io/
- ArtifactHub is like DockerHub, but it includes Helm Charts. (e.g. search wordpress on artifactHub on browser)

![image](https://user-images.githubusercontent.com/10358317/153708626-6715df00-81c0-4314-b2fa-6c6b563a1af1.png)

- With Helm Search on Hub:
```
helm search hub wordpress        # searches package on the Hub
helm search repo wordpress       # searches package on the local machine repository list
helm search repo bitnami         # searches bitnami in the repo list   

```
![image](https://user-images.githubusercontent.com/10358317/153708687-c2542aa5-e763-4967-b8a9-0f4b82ab7af0.png)




- **Repo:** the list on the local machine, repo item includes the package's download page (e.g. https://charts.bitnami.com/bitnami) 

```
helm repo add bitnami https://charts.bitnami.com/bitnami            # adds link into my repo list
helm search repo wordpress                                          # searches package on the local machine repository list
helm repo list                                                      # list all repo
helm pull [chart]
helm pull jenkins/jenkins
helm pull bitnami/jenkins                                           # pull and download chart to the current directory
```

![image](https://user-images.githubusercontent.com/10358317/153730338-0f00f81b-b2e8-4fd9-be3c-3a8acd9e2d2a.png)

![image](https://user-images.githubusercontent.com/10358317/153730367-6ef92437-49bd-47df-8ca2-009301872614.png)

- Install chart on K8s with application/release name
 
```
helm install helm-release-wordpress bitnami/wordpress               # install bitnami/wordpress chart with helm-release-wordpress name on default namespace
helm install release bitnami/wordpress --namespace production       # install release on production namespace
helm install my-release \                                           # possible to set username/password while creating pods
  --set wordpressUsername=admin \
  --set wordpressPassword=password \
  --set mariadb.auth.rootPassword=secretpassword \
    bitnami/wordpress
helm install wordpress-release bitnami/wordpress -f ./values.yaml   # values.yaml includes import values (e.g. username,pass,..), if it is updated and using this file, it is possible to install with these values.     
```

![image](https://user-images.githubusercontent.com/10358317/153709179-d36c5c8a-39d9-4ba4-ab30-243706caa6ae.png)

- To see the status of the release:

```
helm status helm-release-wordpress
```
![image](https://user-images.githubusercontent.com/10358317/153711226-1d058594-9ba9-402d-a422-4f2c95e19070.png)

- We can change/show the values that are the variables (e.g.username,password): 
```
helm show values bitnami/wordpress
```
![image](https://user-images.githubusercontent.com/10358317/153711295-2a25ea75-6ce1-434f-9138-54b262c100f1.png)


- You can see the all K8s objects that are automatically created by Helm

```
kubectl get pods
kubectl get svc
kubectl get deployment
kubectl get pv
kubectl get pvc
kubectl get configmap
kubectl get secrets
kubectl get pods --all-namespace
helm list
```
![image](https://user-images.githubusercontent.com/10358317/153709719-c26478a4-cad5-4d9b-80ab-9302c89629e2.png)

- Get password of wordpress:

![image](https://user-images.githubusercontent.com/10358317/153709965-d702a32a-0041-4c5d-b0de-12b229476dfe.png)

- Open tunnel from minikube:

```
minikube service helm-release-wordpress --url
```

![image](https://user-images.githubusercontent.com/10358317/153709988-8252a1f1-dd56-46a3-a2d5-8ea8e7423a61.png)

![image](https://user-images.githubusercontent.com/10358317/153710041-47838752-ff54-4321-9fc1-e4d37211840d.png)

- Using username and pass (http://127.0.0.1:46007/admin):

![image](https://user-images.githubusercontent.com/10358317/153710100-cc29ac32-4f7d-4c69-a466-31dac86c1f06.png)
![image](https://user-images.githubusercontent.com/10358317/153710112-697852b5-e3c9-4166-9038-f9494b99488f.png)

- Uninstall helm release:

![image](https://user-images.githubusercontent.com/10358317/153711396-c6b4e973-22a3-4246-99a0-026ff4c7c14c.png)
