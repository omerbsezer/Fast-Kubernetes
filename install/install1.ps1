echo "#########################################################"
echo "Script will start in 10 Seconds..."
Start-Sleep -s 10

echo "Firewall rules : Allow All Traffic..."
New-NetFireWallRule -DisplayName "Allow All Traffic" -Direction OutBound -Action Allow  
New-NetFireWallRule -DisplayName "Allow All Traffic" -Direction InBound -Action Allow 

echo "Installing Docker Container..."
Install-WindowsFeature -Name containers  

echo "Installing DockerMsftProvider, Waiting 15 Seconds..."
Start-Sleep -s 15
Install-Module DockerMsftProvider -Force

echo "Installing Package Docker, Waiting 15 Seconds..."
Start-Sleep -s 15
Install-Package Docker -ProviderName DockerMsftProvider -Force 

echo "Setting Service Docker, Waiting 20 Seconds..."
Start-Sleep -s 20
Set-Service -Name docker -StartupType 'Automatic' 
 
echo "Installing additional Windows networking components: RemoteAccess, RSAT-RemoteAccess-PowerShell, Routing, Waiting 10 Seconds..."
Start-Sleep -s 10
Install-WindowsFeature RemoteAccess 

echo "Installing RSAT-RemoteAccess-PowerShell, Waiting 10 Seconds..."
Start-Sleep -s 10
Install-WindowsFeature RSAT-RemoteAccess-PowerShell 

echo "Installing Routing, Waiting 10 Seconds..."
Start-Sleep -s 10
Install-WindowsFeature Routing 

echo "#########################################################"
echo "Docker and network components are installed..."
echo "After Restart, please run INSTALL2.ps1..."
echo "Before to run this install2.ps1, please be sure creating 'k' directory under C directory (c:\k) and includes K8s config file..."
echo "e.g. mkdir c:\k"
echo "e.g. run on the master node:  scp -r /home/ubuntu/.kube/config windowsuser@IP:C:\k"
echo "e.g. or copy the config file content, and paste it on Windows c:\k"
echo "#########################################################"
echo "Computer will be restarted in 10 Seconds..."
Start-Sleep -s 10
Restart-Computer -Force 
