# Jenkins

## Configuration

The following tables list the configurable parameters of the Jenkins chart and their default values.

### Jenkins Controller

| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `checkDeprecation`                | Checks for deprecated values used    | `true`                                 |
| `clusterZone`                     | Override the cluster name for FQDN resolving    | `cluster.local`                |
| `nameOverride`                    | Override the resource name prefix    | `jenkins`                                 |
| `renderHelmLabels`                | Enables rendering of the helm.sh/chart label to the annotations    | `true`                                 |
| `fullnameOverride`                | Override the full resource names     | `jenkins-{release-name}` (or `jenkins` if release-name is `jenkins`) |
| `namespaceOverride`               | Override the deployment namespace    | Not set (`Release.Namespace`)             |
| `controller.componentName`            | Jenkins controller name                  | `jenkins-controller`                          |
| `controller.testEnabled`              | Can be used to disable rendering test resources when using helm template | `true`                         |
| `controller.cloudName`                       | Name of default cloud configuration  | `kubernetes`                              |

#### Jenkins Configuration as Code (JCasC)

| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `controller.JCasC.defaultConfig`      | Enables default Jenkins configuration via configuration as code plugin | `true`  |
| `controller.JCasC.configScripts`      | List of Jenkins Config as Code scripts | `{}`                                    |
| `controller.JCasC.securityRealm`      | Jenkins Config as Code for Security Realm | `legacy`                             |
| `controller.JCasC.authorizationStrategy` | Jenkins Config as Code for Authorization Strategy | `loggedInUsersCanDoAnything` |
| `controller.sidecars.configAutoReload` | Jenkins Config as Code auto-reload settings |                                   |
| `controller.sidecars.configAutoReload.enabled` | Jenkins Config as Code auto-reload settings (Attention: rbac needs to be enabled otherwise the sidecar can't read the config map) | `true`                                                      |
| `controller.sidecars.configAutoReload.image` | Image which triggers the reload | `kiwigrid/k8s-sidecar:0.1.144`           |
| `controller.sidecars.configAutoReload.reqRetryConnect` | How many connection-related errors to retry on  | `10`          |
| `controller.sidecars.configAutoReload.env` | Environment variables for the Jenkins Config as Code auto-reload container  | Not set |
| `controller.sidecars.configAutoReload.containerSecurityContext` | Enable container security context | `{readOnlyRootFilesystem: true, allowPrivilegeEscalation: false}` |

#### Jenkins Configuration Files & Scripts

| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `controller.initScripts`          | List of Jenkins init scripts         | `[]`                                      |
| `controller.initConfigMap`        | Pre-existing init scripts            | Not set                                   |

#### Jenkins Global Security

| Parameter                         | Description                              | Default                                   |
| --------------------------------- | ---------------------------------------- | ----------------------------------------- |
| `controller.adminSecret`              | Create secret for admin user         | `true`                                    |
| `controller.disableRememberMe`        | Disable use of remember me           | `false`                                   |
| `controller.enableRawHtmlMarkupFormatter` | Enable HTML parsing using        | false                                     |
| `controller.markupFormatter`          | Yaml of the markup formatter to use  | `plainText`                               |
| `controller.disabledAgentProtocols`   | Disabled agent protocols             | `JNLP-connect JNLP2-connect`              |
| `controller.csrf.defaultCrumbIssuer.enabled` | Enable the default CSRF Crumb issuer | `true`                             |
| `controller.csrf.defaultCrumbIssuer.proxyCompatability` | Enable proxy compatibility | `true`                            |

#### Jenkins Global Settings

| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `controller.numExecutors`         | Set Number of executors              | 0                                         |
| `controller.executorMode`         | Set executor mode of the Jenkins node. Possible values are: NORMAL or EXCLUSIVE | NORMAL |
| `controller.customJenkinsLabels`  | Append Jenkins labels to the controller  | `[]`                                      |
| `controller.jenkinsHome`          | Custom Jenkins home path             | `/var/jenkins_home`                       |
| `controller.jenkinsRef`           | Custom Jenkins reference path        | `/usr/share/jenkins/ref`                  |
| `controller.jenkinsAdminEmail`    | Email address for the administrator of the Jenkins instance | Not set            |
| `controller.jenkinsUrl`           | Set Jenkins URL if you are not using the ingress definitions provided by the chart | Not set |
| `controller.jenkinsUrlProtocol`   | Set protocol for Jenkins URL | Set to `https` if `controller.ingress.tls`, `http` otherwise |
| `controller.jenkinsUriPrefix`     | Root Uri Jenkins will be served on   | Not set                                   |

#### Jenkins In-Process Script Approval

| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `controller.scriptApproval`       | List of groovy functions to approve  | `[]`                                      |

#### Jenkins Plugins

| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `controller.installPlugins`       | List of Jenkins plugins to install. If you don't want to install plugins set it to `false` | `kubernetes:1.29.2 workflow-aggregator:2.6 git:4.7.1 configuration-as-code:1.47` |
| `controller.additionalPlugins`    | List of Jenkins plugins to install in addition to those listed in controller.installPlugins | `[]` |
| `controller.initializeOnce`       | Initialize only on first install. Ensures plugins do not get updated inadvertently. Requires `persistence.enabled` to be set to `true`. | `false` |
| `controller.overwritePlugins`     | Overwrite installed plugins on start.| `false`                                   |
| `controller.overwritePluginsFromImage` | Keep plugins that are already installed in the controller image.| `true`            |
| `controller.installLatestPlugins`      | Set to false to download the minimum required version of all dependencies. | `true` |
| `controller.installLatestSpecifiedPlugins`      | Set to true to download latest dependencies of any plugin that is requested to have the latest version. | `false` |

#### Jenkins Agent Listener

| Parameter                                    | Description                                     | Default      |
| -------------------------------------------- | ----------------------------------------------- | ------------ |
| `controller.agentListenerEnabled`            | Create Agent listener service                   | `true`       |
| `controller.agentListenerPort`               | Listening port for agents                       | `50000`      |
| `controller.agentListenerHostPort`           | Host port to listen for agents                  | Not set      |
| `controller.agentListenerNodePort`           | Node port to listen for agents                  | Not set      |
| `controller.agentListenerServiceType`        | Defines how to expose the agentListener service | `ClusterIP`  |
| `controller.agentListenerServiceAnnotations` | Annotations for the agentListener service       | `{}`         |
| `controller.agentListenerLoadBalancerIP`     | Static IP for the agentListener LoadBalancer    | Not set      |

#### Kubernetes StatefulSet & Service

| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `controller.image`                    | Controller image name                     | `jenkins/jenkins`                         |
| `controller.tagLabel`                 | Controller image tag label                | `jdk11`                                   |
| `controller.tag`                      | Controller image tag override             | Not set                                   |
| `controller.imagePullPolicy`          | Controller image pull policy              | `Always`                                  |
| `controller.imagePullSecretName`      | Controller image pull secret              | Not set                                   |
| `controller.resources`                | Resources allocation (Requests and Limits) | `{requests: {cpu: 50m, memory: 256Mi}, limits: {cpu: 2000m, memory: 4096Mi}}`|
| `controller.initContainerResources`   | Resources allocation (Requests and Limits) for Init Container            | Not set |
| `controller.initContainerEnv`         | Environment variables for Init Container                                 | Not set |
| `controller.containerEnv`             | Environment variables for Jenkins Container                              | Not set |
| `controller.usePodSecurityContext`    | Enable pod security context (must be `true` if `runAsUser`, `fsGroup`, or `podSecurityContextOverride` are set) | `true` |
| `controller.runAsUser`                | Deprecated in favor of `controller.podSecurityContextOverride`.  uid that jenkins runs with. | `1000`                                    |
| `controller.fsGroup`                  | Deprecated in favor of `controller.podSecurityContextOverride`.  uid that will be used for persistent volume. | `1000`                             |
| `controller.podSecurityContextOverride` | Completely overwrites the contents of the pod security context, ignoring the values provided for `runAsUser`, and `fsGroup`. | Not set |
| `controller.containerSecurityContext`    | Allow to control securityContext for the jenkins container. | `{runAsUser: 1000, runAsGroup: 1000, readOnlyRootFilesystem: true, allowPrivilegeEscalation: false}` |
| `controller.hostAliases`              | Aliases for IPs in `/etc/hosts`      | `[]`                                      |
| `controller.serviceAnnotations`       | Service annotations                  | `{}`                                      |
| `controller.serviceType`              | k8s service type                     | `ClusterIP`                               |
| `controller.clusterIP`                | k8s service clusterIP                | Not set                                   |
| `controller.servicePort`              | k8s service port                     | `8080`                                    |
| `controller.targetPort`               | k8s target port                      | `8080`                                    |
| `controller.nodePort`                 | k8s node port                        | Not set                                   |
| `controller.jmxPort`                  | Open a port, for JMX stats           | Not set                                   |
| `controller.extraPorts`               | Open extra ports, for other uses     | `[]`                                      |
| `controller.loadBalancerSourceRanges` | Allowed inbound IP addresses         | `0.0.0.0/0`                               |
| `controller.loadBalancerIP`           | Optional fixed external IP           | Not set                                   |
| `controller.statefulSetLabels`        | Custom StatefulSet labels            | Not set                                   |
| `controller.serviceLabels`            | Custom Service labels                | Not set                                   |
| `controller.podLabels`                | Custom Pod labels (an object with `label-key: label-value` pairs)                    | Not set                                   |
| `controller.nodeSelector`             | Node labels for pod assignment       | `{}`                                      |
| `controller.affinity`                 | Affinity settings                    | `{}`                                      |
| `controller.schedulerName`            | Kubernetes scheduler name            | Not set                                   |
| `controller.terminationGracePeriodSeconds` | Set TerminationGracePeriodSeconds   | Not set                               |
| `controller.terminationMessagePath` | Set the termination message path   | Not set                               |
| `controller.terminationMessagePolicy` | Set the termination message policy   | Not set                               |
| `controller.tolerations`              | Toleration labels for pod assignment | `[]`                                      |
| `controller.podAnnotations`           | Annotations for controller pod           | `{}`                                      |
| `controller.statefulSetAnnotations`   | Annotations for controller StatefulSet   | `{}`                                      |
| `controller.updateStrategy`           | Update strategy for StatefulSet      | `{}`                                      |
| `controller.lifecycle`                | Lifecycle specification for controller-container | Not set                           |
| `controller.priorityClassName`        | The name of a `priorityClass` to apply to the controller pod | Not set               |
| `controller.admin.existingSecret`     | The name of an existing secret containing the admin credentials. | `""`|
| `controller.admin.userKey`            | The key in the existing admin secret containing the username. | `jenkins-admin-user` |
| `controller.admin.passwordKey`        | The key in the existing admin secret containing the password. | `jenkins-admin-password` |
| `controller.customInitContainers`     | Custom init-container specification in raw-yaml format | Not set                 |
| `controller.sidecars.other`           | Configures additional sidecar container(s) for Jenkins controller | `[]`             |

#### Kubernetes Pod Disruption Budget

| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `controller.podDisruptionBudget.enabled` | Enable [Kubernetes Pod Disruption Budget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) configuration from `controller.podDisruptionBudget` (see below) | `false` |
| `controller.podDisruptionBudget.apiVersion` | Policy API version | `policy/v1beta1` |
| `controller.podDisruptionBudget.maxUnavailable` | Number of pods that can be unavailable. Either an absolute number or a percentage. | Not set |

#### Kubernetes Health Probes

| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `controller.healthProbes`             | Enable [Kubernetes Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes) configuration from `controller.probes` (see below) | `true` |
| `controller.probes.livenessProbe.timeoutSeconds` | Set the timeout for the liveness probe in seconds  | `5` |
| `controller.probes.livenessProbe.periodSeconds` | Set the time interval (in seconds) between two liveness probes executions | `10` |
| `controller.probes.livenessProbe.failureThreshold` | Set the failure threshold for the liveness probe | `5` |
| `controller.probes.livenessProbe.initialDelaySeconds` | Set the initial delay for the liveness probe | Not set |
| `controller.probes.livenessProbe.httpGet.port` | Set the Pod's HTTP port to use for the liveness probe | `http` |
| `controller.probes.livenessProbe.httpGet.path` | Set the HTTP's path for the liveness probe | `/login'` (or `${controller.jenkinsUriPrefix}/login` if `controller.jenkinsUriPrefix` is defined) |
| `controller.probes.readinessProbe.timeoutSeconds` | Set the timeout for the readiness probe in seconds  | `5` |
| `controller.probes.readinessProbe.periodSeconds` | Set the time interval (in seconds) between two readiness probes executions | `10` |
| `controller.probes.readinessProbe.failureThreshold` | Set the failure threshold for the readiness probe | `3` |
| `controller.probes.readinessProbe.initialDelaySeconds` | Set the initial delay for the readiness probe | Not set |
| `controller.probes.readinessProbe.httpGet.port` | Set the Pod's HTTP port to use for the readiness probe | `http` |
| `controller.probes.readinessProbe.httpGet.path` | Set the HTTP's path for the readiness probe | `/login'` (or `${controller.jenkinsUriPrefix}/login` if `controller.jenkinsUriPrefix` is defined) |
| `controller.probes.startupProbe.timeoutSeconds` | Set the timeout for the startup probe in seconds  | `5` |
| `controller.probes.startupProbe.periodSeconds` | Set the time interval (in seconds) between two startup probes executions | `10` |
| `controller.probes.startupProbe.failureThreshold` | Set the failure threshold for the startup probe | `12` |
| `controller.probes.startupProbe.initialDelaySeconds` | Set the initial delay for the startup probe | Not set |
| `controller.probes.startupProbe.httpGet.port` | Set the Pod's HTTP port to use for the startup probe | `http` |
| `controller.probes.startupProbe.httpGet.path` | Set the HTTP's path for the startup probe | `/login'` (or `${controller.jenkinsUriPrefix}/login` if `controller.jenkinsUriPrefix` is defined) |

#### Kubernetes Ingress

| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `controller.ingress.enabled`          | Enables ingress                      | `false`                                   |
| `controller.ingress.apiVersion`       | Ingress API version                  | `extensions/v1beta1`                      |
| `controller.ingress.hostName`         | Ingress host name                    | Not set                                   |
| `controller.ingress.resourceRootUrl`  | Hostname to serve assets from        | Not set                                   |
| `controller.ingress.annotations`      | Ingress annotations                  | `{}`                                      |
| `controller.ingress.labels`           | Ingress labels                       | `{}`                                      |
| `controller.ingress.path`             | Ingress path                         | Not set                                   |
| `controller.ingress.paths`            | Override for the default Ingress paths  | `[]`                                   |
| `controller.ingress.tls`              | Ingress TLS configuration            | `[]`                                      |

#### GKE BackendConfig

| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `controller.backendconfig.enabled`     | Enables backendconfig     | `false`              |
| `controller.backendconfig.apiVersion`  | backendconfig API version | `extensions/v1beta1` |
| `controller.backendconfig.name`        | backendconfig name        | Not set              |
| `controller.backendconfig.annotations` | backendconfig annotations | `{}`                 |
| `controller.backendconfig.labels`      | backendconfig labels      | `{}`                 |
| `controller.backendconfig.spec`        | backendconfig spec        | `{}`                 |

#### OpenShift Route

| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `controller.route.enabled`            | Enables openshift route              | `false`                                   |
| `controller.route.annotations`        | Route annotations                    | `{}`                                      |
| `controller.route.labels`             | Route labels                         | `{}`                                      |
| `controller.route.path`               | Route path                           | Not set                                   |

#### Prometheus

| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `controller.prometheus.enabled`       | Enables prometheus service monitor | `false`                                     |
| `controller.prometheus.serviceMonitorAdditionalLabels` | Additional labels to add to the service monitor object | `{}`                       |
| `controller.prometheus.serviceMonitorNamespace` | Custom namespace for serviceMonitor | Not set (same ns where is Jenkins being deployed) |
| `controller.prometheus.scrapeInterval` | How often prometheus should scrape metrics | `60s`                              |
| `controller.prometheus.scrapeEndpoint` | The endpoint prometheus should get metrics from | `/prometheus`                 |
| `controller.prometheus.alertingrules` | Array of prometheus alerting rules | `[]`                                        |
| `controller.prometheus.alertingRulesAdditionalLabels` | Additional labels to add to the prometheus rule object     | `{}`                                   |
| `controller.prometheus.prometheusRuleNamespace` | Custom namespace for PrometheusRule | `""` (same ns where Jenkins being deployed) |

#### HTTPS Keystore

| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `controller.httpsKeyStore.enable`     | Enables https keystore on jenkins controller      | `false`      |
| `controller.httpsKeyStore.jenkinsHttpsJksSecretName`     | Name of the secret that already has ssl keystore      | ``      |
| `controller.httpsKeyStore.httpPort`   | Http Port that Jenkins should listen on along with https, it also serves liveness and readiness probs port. When https keystore is enabled servicePort and targetPort will be used as https port  | `8081`   |
| `controller.httpsKeyStore.path`       | Path of https keystore file                  |     `/var/jenkins_keystore`     |
| `controller.httpsKeyStore.fileName`  | Jenkins keystore filename which will appear under controller.httpsKeyStore.path      | `keystore.jks` |
| `controller.httpsKeyStore.password`   | Jenkins keystore password                                           | `password` |
| `controller.httpsKeyStore.jenkinsKeyStoreBase64Encoded`  | Base64 encoded Keystore content. Keystore must be converted to base64 then being pasted here  | a self signed cert |

#### Kubernetes Secret

| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `controller.adminUser`                | Admin username (and password) created as a secret if adminSecret is true | `admin` |
| `controller.adminPassword`            | Admin password (and user) created as a secret if adminSecret is true | Random value |
| `controller.additionalSecrets`        | List of additional secrets to create and mount according to [JCasC docs](https://github.com/jenkinsci/configuration-as-code-plugin/blob/master/docs/features/secrets.adoc#kubernetes-secrets) | `[]` |
| `controller.additionalExistingSecrets`| List of additional existing secrets to mount according to [JCasC docs](https://github.com/jenkinsci/configuration-as-code-plugin/blob/master/docs/features/secrets.adoc#kubernetes-secrets) | `[]` |
| `controller.secretClaims`             | List of `SecretClaim` resources to create | `[]` |

#### Kubernetes NetworkPolicy

| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `networkPolicy.enabled`           | Enable creation of NetworkPolicy resources. | `false`                            |
| `networkPolicy.apiVersion`        | NetworkPolicy ApiVersion             | `networking.k8s.io/v1`                    |
| `networkPolicy.internalAgents.allowed`           | Allow internal agents (from the same cluster) to connect to controller. Agent pods would be filtered based on PodLabels. | `false`                            |
| `networkPolicy.internalAgents.podLabels`           | A map of labels (keys/values) that agents pods must have to be able to connect to controller. | `{}`                            |
| `networkPolicy.internalAgents.namespaceLabels`           | A map of labels (keys/values) that agents namespaces must have to be able to connect to controller. | `{}`                            |
| `networkPolicy.externalAgents.ipCIDR`           | The IP range from which external agents are allowed to connect to controller. | ``                            |
| `networkPolicy.externalAgents.except`           | A list of IP sub-ranges to be excluded from the whitelisted IP range. | `[]`                            |

#### Kubernetes RBAC

| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `rbac.create`                     | Whether RBAC resources are created   | `true`                                    |
| `rbac.readSecrets`                | Whether the Jenkins service account should be able to read Kubernetes secrets    | `false` |

#### Kubernetes ServiceAccount - Controller

| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `serviceAccount.name`             | name of the ServiceAccount to be used by access-controlled resources | autogenerated |
| `serviceAccount.create`           | Configures if a ServiceAccount with this name should be created | `true`         |
| `serviceAccount.annotations`      | Configures annotation for the ServiceAccount | `{}`                              |
| `serviceAccount.imagePullSecretName` | Controller ServiceAccount image pull secret   | Not set                       |

#### Kubernetes ServiceAccount - Agent

| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `serviceAccountAgent.name`        | name of the agent ServiceAccount to be used by access-controlled resources | autogenerated |
| `serviceAccountAgent.create`      | Configures if an agent ServiceAccount with this name should be created | `false`         |
| `serviceAccountAgent.annotations` | Configures annotation for the agent ServiceAccount | `{}`                              |
| `serviceAccountAgent.imagePullSecretName` | Agent ServiceAccount image pull secret   | Not set                       |

### Jenkins Agent(s)

| Parameter                  | Description                                     | Default                |
| -------------------------- | ----------------------------------------------- | ---------------------- |
| `agent.enabled`            | Enable Kubernetes plugin jnlp-agent podTemplate | `true`                 |
| `agent.namespace`          | Namespace in which the Kubernetes agents should be launched  | Not set   |
| `agent.containerCap`       | Maximum number of agent                         | 10                     |
| `agent.defaultsProviderTemplate` | The name of the pod template to use for providing default values | Not set  |
| `agent.jenkinsUrl`          | Overrides the Kubernetes Jenkins URL    | Not set                                |
| `agent.jenkinsTunnel`       | Overrides the Kubernetes Jenkins tunnel | Not set                                |
| `agent.kubernetesConnectTimeout` | The connection timeout in seconds for connections to Kubernetes API. Minimum value is 5. | 5 |
| `agent.kubernetesReadTimeout` | The read timeout in seconds for connections to Kubernetes API. Minimum value is 15. | 15 |
| `agent.maxRequestsPerHostStr` | The maximum concurrent connections to Kubernetes API | 32 |
| `agent.podLabels`             | Custom Pod labels (an object with `label-key: label-value` pairs)                    | Not set                         |

#### Pod Configuration

| Parameter                  | Description                                     | Default                |
| -------------------------- | ----------------------------------------------- | ---------------------- |
| `agent.websocket`          | Enables agent communication via websockets      | false                  |
| `agent.podName`            | Agent Pod base name                             | Not set                |
| `agent.customJenkinsLabels`| Append Jenkins labels to the agent              | `[]`                   |
| `agent.envVars`            | Environment variables for the agent Pod         | `[]`                   |
| `agent.idleMinutes`        | Allows the Pod to remain active for reuse       | 0                      |
| `agent.imagePullSecretName` | Agent image pull secret                        | Not set                |
| `agent.nodeSelector`       | Node labels for pod assignment                  | `{}`                   |
| `agent.connectTimeout`     | Timeout in seconds for an agent to be online    | 100                    |
| `agent.volumes`            | Additional volumes                              | `[]`                   |
| `agent.workspaceVolume`    | Workspace volume (defaults to EmptyDir)         | `{}`                   |
| `agent.yamlTemplate`       | The raw yaml of a Pod API Object to merge into the agent spec | Not set  |
| `agent.yamlMergeStrategy`   | Defines how the raw yaml field gets merged with yaml definitions from inherited pod templates | `override` |
| `agent.annotations`       | Annotations to apply to the pod                  | `{}`                   |

#### Side Container Configuration

| Parameter                  | Description                                     | Default                |
| -------------------------- | ----------------------------------------------- | ---------------------- |
| `agent.sideContainerName`  | Side container name in agent                    | jnlp                   |
| `agent.image`              | Agent image name                                | `jenkins/inbound-agent`|
| `agent.tag`                | Agent image tag                                 | `4.11.2-4`             |
| `agent.alwaysPullImage`    | Always pull agent container image before build  | `false`                |
| `agent.privileged`         | Agent privileged container                      | `false`                |
| `agent.resources`          | Resources allocation (Requests and Limits)      | `{requests: {cpu: 512m, memory: 512Mi}, limits: {cpu: 512m, memory: 512Mi}}` |
| `agent.runAsUser`          | Configure container user                        | Not set                |
| `agent.runAsGroup`         | Configure container group                       | Not set                |
| `agent.command`            | Executed command when side container starts     | Not set                |
| `agent.args`               | Arguments passed to executed command            | `${computer.jnlpmac} ${computer.name}` |
| `agent.TTYEnabled`         | Allocate pseudo tty to the side container       | false                  |
| `agent.workingDir`         | Configure working directory for default agent   | `/home/jenkins/agent`  |

#### Other

| Parameter                  | Description                                     | Default                |
| -------------------------- | ----------------------------------------------- | ---------------------- |
| `agent.podTemplates`       | Configures extra pod templates for the default kubernetes cloud | `{}`   |
| `additionalAgents`         | Configure additional agents which inherit values from `agent` | `{}`     |

### Persistence

| Parameter                   | Description                     | Default         |
| --------------------------- | ------------------------------- | --------------- |
| `persistence.enabled`       | Enable the use of a Jenkins PVC | `true`          |
| `persistence.existingClaim` | Provide the name of a PVC       | `nil`           |
| `persistence.storageClass`  | Storage class for the PVC       | `nil`           |
| `persistence.annotations`   | Annotations for the PVC         | `{}`            |
| `persistence.labels`        | Labels for the PVC              | `{}`            |
| `persistence.accessMode`    | The PVC access mode             | `ReadWriteOnce` |
| `persistence.size`          | The size of the PVC             | `8Gi`           |
| `persistence.subPath`       | SubPath for jenkins-home mount  | `nil`           |
| `persistence.volumes`       | Additional volumes              | `nil`           |
| `persistence.mounts`        | Additional mounts               | `nil`           |

### Backup

| Parameter                                | Description                                                       | Default                           |
| ---------------------------------------- | ----------------------------------------------------------------- | --------------------------------- |
| `backup.enabled`                         | Enable the use of a backup CronJob                                | `false`                           |
| `backup.schedule`                        | Schedule to run jobs                                              | `0 2 * * *`                       |
| `backup.labels`                          | Backup pod labels                                                 | `{}`                              |
| `backup.serviceAccount.create`           | Specifies whether a ServiceAccount should be created              | `true`                            |
| `backup.serviceAccount.name`             | name of the backup ServiceAccount                                 | autogenerated                     |
| `backup.serviceAccount.annotations`      | Backup pod annotations                                            | `{}`                              |
| `backup.image.repo`                      | Backup image repository                                           | `maorfr/kube-tasks`               |
| `backup.image.tag`                       | Backup image tag                                                  | `0.2.0`                           |
| `backup.extraArgs`                       | Additional arguments for kube-tasks                               | `[]`                              |
| `backup.existingSecret`                  | Environment variables to add to the cronjob container             | `{}`                              |
| `backup.existingSecret.*`                | Specify the secret name containing the AWS or GCP credentials     | `jenkinsaws`                      |
| `backup.existingSecret.*.awsaccesskey`   | `secretKeyRef.key` used for `AWS_ACCESS_KEY_ID`                   | `jenkins_aws_access_key`          |
| `backup.existingSecret.*.awssecretkey`   | `secretKeyRef.key` used for `AWS_SECRET_ACCESS_KEY`               | `jenkins_aws_secret_key`          |
| `backup.existingSecret.*.azstorageaccount`| `secretKeyRef.key` used for `AZURE_STORAGE_ACCOUNT`               | `""`                              |
| `backup.existingSecret.*.azstoragekey`    | `secretKeyRef.key` used for `AZURE_STORAGE_ACCESS_KEY`            | `""`                          |
| `backup.existingSecret.*.gcpcredentials` | Mounts secret as volume and sets `GOOGLE_APPLICATION_CREDENTIALS` | `credentials.json`                |
| `backup.env`                             | Backup environment variables                                      | `[]`                              |
| `backup.resources`                       | Backup CPU/Memory resource requests/limits                        | Memory: `1Gi`, CPU: `1`           |
| `backup.destination`                     | Destination to store backup artifacts                             | `s3://jenkins-data/backup`        |
| `backup.onlyJobs`                        | Only backup the job folder                                        | `false`                           |
| `backup.usePodSecurityContext`           | Enable backup pod's security context (must be `true` if `runAsUser`, `fsGroup`, or `podSecurityContextOverride` are set) | `true` |
| `backup.runAsUser`                       | Deprecated in favor of `backup.podSecurityContextOverride`.  uid that jenkins runs with. | `1000`                                    |
| `backup.fsGroup`                         | Deprecated in favor of `backup.podSecurityContextOverride`.  uid that will be used for persistent volume. | `1000`                             |
| `backup.podSecurityContextOverride`      | Completely overwrites the contents of the backup pod's security context, ignoring the values provided for `runAsUser`, and `fsGroup`. | Not set |
| `awsSecurityGroupPolicies.enabled`      | Enable the creation of SecurityGroupPolicy resources | `false` |
| `awsSecurityGroupPolicies.policies` | Security Group Policy definitions. `awsSecurityGroupPolicies.enabled` must be `true`  | Not set |
