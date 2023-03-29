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
Invoke-WebRequest https://github.com/projectcalico/calico/releases/download/v3.25.0/install-calico-windows.ps1 -OutFile c:\install-calico-windows.ps1
c:\install-calico-windows.ps1 -DownloadOnly yes -KubeVersion 1.23.5
Get-Service -Name CalicoNode 
Get-Service -Name CalicoFelix 

echo "Installing Kubelet Service, Waiting 10 Seconds..."
Start-Sleep -s 10
C:\CalicoWindows\kubernetes\install-kube-services.ps1 
Start-Service -Name kubelet 
Start-Service -Name kube-proxy 
 
echo "Testing kubectl..."
kubectl get nodes -o wide     

echo "#########################################################"
echo "Congrulations, kubernetes installed on Win..." 
echo "Calico Ref: https://docs.tigera.io/calico/latest/getting-started/kubernetes/windows-calico/kubernetes/standard"
echo "#########################################################"
