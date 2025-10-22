# Quick Start Guide

Getting Meshery up and running locally on a Docker-enabled system or in Kubernetes is easy. Meshery deploys as a set of Docker containers, which can be deployed to either a Docker host or Kubernetes cluster.

> This quick start guide enables you to download, install, and run Meshery in a single command. See all [supported platforms](#platforms)</a> for more specific (and less presumptious) instructions.

## 1. Download, install, and run Meshery

If you are on macOS or Linux system, you can download, install, and run both `mesheryctl` and Meshery Server by executing the following command.

<!-- <pre class="codeblock-pre" style="padding: 0; font-size:0px;">
<div class="codeblock" style="display: block;">
  <div class="clipboardjs" style="visibility:hidden;padding: 0;">
    <span style="visibility:hidden">curl -L https://meshery.io/install | PLATFORM=kubernetes bash -</span>
  </div>
  <div class="window-buttons"></div>
  <div id="termynal0" style="width:fit-content;min-height:content-fit;" data-termynal="">
    <span data-ty="input">curl -L https://meshery.io/install | PLATFORM=kubernetes bash -</span>
  </div>
</div>
</pre>-->
<!-- <script src="/assets/js/terminal.js" data-termynal-container="#termynal0"></script> -->

<pre class="codeblock-pre">
  <div class="codeblock">
  <div class="clipboardjs">$ curl -L https://meshery.io/install | PLATFORM=kubernetes bash -</div>
  </div>
</pre>

>Meshery's command line interface, <code>mesheryctl</code>, can be installed in <a href='https://docs.meshery.io/installation/mesheryctl'>various ways</a>. In addition to <a href='https://docs.meshery.io/installation/linux-mac/bash'>Bash</a>, you can also use <a href='https://docs.meshery.io/installation/linux-mac/brew'>Brew</a> or <a href='https://docs.meshery.io/installation/windows/scoop'>Scoop</a> to install <code>mesheryctl</code>. Alternatively, <code>mesheryctl</code> is also available via <a href='https://github.com/meshery/meshery/releases/latest'>direct download</a>.

## 2. Access Meshery

Your default browser will be opened and directed to Meshery's web-based user interface typically found at `http://localhost:9081`.

#### Accessing Meshery Server with Meshery UI

Meshery's web-based user interface is embedded in Meshery Server and is available as soon as Meshery starts. The location and port that Meshery UI is exposed varies depending upon your mode of deployment. See <a href='https://docs.meshery.io/installation/accessing-meshery-ui'>accessing Meshery UI</a> for deployment-specific details.

#### Accessing Meshery Server with Meshery CLI 
Meshery's command line interface is a client of Meshery Server's REST API (just as Meshery UI is). Choose to use <code>mesheryctl</code> as an alternative client as it suits your needs.

### 3. Select a Provider

Select from the list of [Providers](https://docs.meshery.io/extensibility/providers) in order to login to Meshery. Authenticate with your chosen Provider.

<a href="https://docs.meshery.io/assets/img/meshery-server-page.png">
  <img class="center" style="width:min(100%,650px)" src="https://docs.meshery.io/assets/img/meshery-server-page.png" />
</a>

## 4. Configure Connections to your Kubernetes Clusters

**Out-of-Cluster Deployments**
If you have deployed Meshery out-of-cluster, Meshery Server will automatically attempt to connect to any available Kubernetes clusters found in your kubeconfig (under `$HOME/.kube/config`) and in kubeconfigs uploaded through Meshery UI. Meshery Server deploys [Meshery Operator](/concepts/architecture/operator), [MeshSync](/concepts/architecture/meshsync), and Broker into the `meshery` namespace (by default).

**In-Cluster Deployments**
If you have deployed Meshery in-cluster, Meshery Server will automatically connect to the Kubernetes API Server available in the control plane.

Visit <i class="fas fa-cog"></i> Settings:

<a href="https://docs.meshery.io/assets/img/platforms/meshery-settings.png">
  <img class="center" style="width:min(100%,650px);" src="https://docs.meshery.io/assets/img/platforms/meshery-settings.png" />
</a>

If your config has not been autodetected, you can manually upload your kubeconfig file (or any number of kubeconfig files). By default, Meshery will attempt to connect to and deploy Meshery Operator to each reachable context contained in the imported kubeconfig files. See Managing Kubernetes Clusters for more information.

## 5. Verify Deployment

Run connectivity tests and verify the health of your Meshery system. Verify Meshery's connection to your Kubernetes clusters by clicking on the connection chip. A quick connectivity test will run and inform you of Meshery's ability to reach and authenticate to your Kubernetes control plane(s). You will be notified of your connection status. You can also verify any other connection between Meshery and either its components (like [Meshery Adapters]({{ site.baseurl }}/concepts/architecture/adapters)) or other managed infrastructure by clicking on any of the connection chips. When clicked, a chip will perform an ad hoc connectivity test.

<a href="https://docs.meshery.io/assets/img/platforms/k8s-context-switcher.png" alt="Meshery Kubernetes Context Switcher">
  <img class="center" style="width:min(100%,350px);" src="https://docs.meshery.io/assets/img/platforms/k8s-context-switcher.png" />
</a>

## 5. Design and operate Kubernetes clusters and their workloads

You may now proceed to managed any cloud native infrastructure supported by Meshery. See all integrations for a complete list of supported infrastructure.

<a href="https://docs.meshery.io/assets/img/platforms/meshery-designs.png">
  <img class="center" style="width:min(100%,650px);" src="https://docs.meshery.io/assets/img/platforms/meshery-designs.png" />
</a>

# Quick Start with <a name="platforms"></a>

- [AKS](https://docs.meshery.io/installation/kubernetes/aks) - Manage your AKS clusters with Meshery. Deploy Meshery in AKS in-cluster or out-of-cluster.
- [Bash](https://docs.meshery.io/installation/linux-mac/bash) - Install Meshery CLI on Linux or MacOS with Bash
- [Brew](https://docs.meshery.io/installation/linux-mac/brew)- Install Meshery CLI on Linux or MacOS with Brew
- [Codespaces](https://docs.meshery.io/installation/codespaces) - Build and contribute to Meshery using GitHub Codespaces
- [Compatibility Matrix](https://docs.meshery.io/installation/compatibility-matrix) - An installation compatibility matrix and project test status dashboard.
- [Docker Extension](https://docs.meshery.io/installation/docker/docker-extension) - Install Docker Extension for Meshery
- [Docker](https://docs.meshery.io/installation/docker) - Install Meshery on Docker
- [EKS](https://docs.meshery.io/installation/kubernetes/eks) - Install Meshery on Elastic Kubernetes Service. Deploy Meshery in EKS in-cluster or outside of EKS out-of-cluster.
- [GKE](https://docs.meshery.io/installation/kubernetes/gke) - Install Meshery on Google Kubernetes Engine. Deploy Meshery in GKE in-cluster or outside of GKE out-of-cluster.
- [Helm](https://docs.meshery.io/installation/kubernetes/helm) - Install Meshery on Kubernetes using Helm. Deploy Meshery in Kubernetes in-cluster.
- [KinD](https://docs.meshery.io/installation/kubernetes/kind) - Install Meshery on KinD. Deploy Meshery in KinD in-cluster or outside of KinD out-of-cluster.
- [Kubernetes](https://docs.meshery.io/installation/kubernetes) - Install Meshery on Kubernetes. Deploy Meshery in Kubernetes in-cluster or outside of Kubernetes out-of-cluster.
- [KubeSphere](https://docs.meshery.io/installation/kubernetes/kubesphere) - Install Meshery on KubeSphere
- [Install Meshery CLI on Linux or Mac](https://docs.meshery.io/installation/linux-mac) - Install Meshery CLI on Linux or Mac
- [Minikube](https://docs.meshery.io/installation/kubernetes/minikube)- Install Meshery on Minikube. Deploy Meshery in Minikube in-cluster or outside of Minikube out-of-cluster.
- [Meshery Playground](https://docs.meshery.io/installation/playground)- Details of the cloud native playground
- [Scoop](https://docs.meshery.io/installation/windows/scoop)  - Install Meshery CLI on Windows with Scoop
- [Install Meshery CLI on Windows](https://docs.meshery.io/installation/windows) - Install Meshery CLI on Windows
