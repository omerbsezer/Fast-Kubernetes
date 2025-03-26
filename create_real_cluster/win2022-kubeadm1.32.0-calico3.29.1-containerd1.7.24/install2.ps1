echo "#########################################################"
echo "Before to run this script, please be sure creating 'k' directory under C directory (c:\k) and includes K8s config file..."
echo "e.g. mkdir c:\k"
echo "e.g. run on the master node:  scp -r /home/ubuntu/.kube/config windowsuser@IP:C:\k"
echo "#########################################################"
echo "Script will start in 10 Seconds..."
Start-Sleep -s 10

echo "Installing remote access..."
Install-RemoteAccess -VpnType RoutingOnly 
Set-Service -Name RemoteAccess -StartupType 'Automatic' 
start-service RemoteAccess 

echo "Installing Calico, Waiting 10 Seconds..."
Start-Sleep -s 10
Invoke-WebRequest -Uri https://github.com/projectcalico/calico/releases/download/v3.29.2/install-calico-windows.ps1 -OutFile c:\install-calico-windows.ps1
c:\install-calico-windows.ps1 -ReleaseBaseURL "https://github.com/projectcalico/calico/releases/download/v3.29.2" -ReleaseFile "calico-windows-v3.29.2.zip" -KubeVersion "1.32.0" -DownloadOnly "yes" -ServiceCidr "10.96.0.0/24" -DNSServerIPs "127.0.0.1"

$ENV:CNI_BIN_DIR="c:\program files\containerd\cni\bin"
$ENV:CNI_CONF_DIR="c:\program files\containerd\cni\conf"
c:\calicowindows\install-calico.ps1
c:\calicowindows\start-calico.ps1

echo "Installing Kubelet Service, Waiting 10 Seconds..."
Start-Sleep -s 10
c:\calicowindows\kubernetes\install-kube-services.ps1
New-NetFirewallRule -Name 'Kubelet-In-TCP' -DisplayName 'Kubelet (node)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 10250
Start-Service -Name kubelet 
Start-Service -Name kube-proxy 

echo "Testing kubectl..."
kubectl get nodes -o wide   


echo "#########################################################"
echo "Congrulations, kubernetes installed on Win..." 
echo "Calico Ref: https://docs.tigera.io/calico/latest/getting-started/kubernetes/windows-calico/kubernetes/standard"
echo "#########################################################"
# ref: https://medium.com/@lubomir-tobek/kubernetes-cluster-and-adding-a-windows-worker-node-0a5b65bffbaa
