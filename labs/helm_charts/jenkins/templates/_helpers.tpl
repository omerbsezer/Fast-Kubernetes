{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "jenkins.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Expand the label of the chart.
*/}}
{{- define "jenkins.label" -}}
{{- printf "%s-%s" (include "jenkins.name" .) .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts.
*/}}
{{- define "jenkins.namespace" -}}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}

{{- define "jenkins.agent.namespace" -}}
  {{- if .Values.agent.namespace -}}
    {{- tpl .Values.agent.namespace . -}}
  {{- else -}}
    {{- if .Values.namespaceOverride -}}
      {{- .Values.namespaceOverride -}}
    {{- else -}}
      {{- .Release.Namespace -}}
    {{- end -}}
  {{- end -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "jenkins.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Returns the admin password
https://github.com/helm/charts/issues/5167#issuecomment-619137759
*/}}
{{- define "jenkins.password" -}}
  {{ if .Values.controller.adminPassword -}}
    {{- .Values.controller.adminPassword | b64enc | quote }}
  {{- else -}}
    {{- $secret := (lookup "v1" "Secret" .Release.Namespace (include "jenkins.fullname" .)).data -}}
    {{- if $secret -}}
      {{/*
        Reusing current password since secret exists
      */}}
      {{- index $secret ( .Values.controller.admin.passwordKey | default "jenkins-admin-password" ) -}}
    {{- else -}}
      {{/*
          Generate new password
      */}}
      {{- randAlphaNum 22 | b64enc | quote }}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
Returns the Jenkins URL
*/}}
{{- define "jenkins.url" -}}
{{- if .Values.controller.jenkinsUrl }}
  {{- .Values.controller.jenkinsUrl }}
{{- else }}
  {{- if .Values.controller.ingress.hostName }}
    {{- if .Values.controller.ingress.tls }}
      {{- default "https" .Values.controller.jenkinsUrlProtocol }}://{{ .Values.controller.ingress.hostName }}{{ default "" .Values.controller.jenkinsUriPrefix }}
    {{- else }}
      {{- default "http" .Values.controller.jenkinsUrlProtocol }}://{{ .Values.controller.ingress.hostName }}{{ default "" .Values.controller.jenkinsUriPrefix }}
    {{- end }}
  {{- else }}
      {{- default "http" .Values.controller.jenkinsUrlProtocol }}://{{ template "jenkins.fullname" . }}:{{.Values.controller.servicePort}}{{ default "" .Values.controller.jenkinsUriPrefix }}
  {{- end}}
{{- end}}
{{- end -}}

{{/*
Returns configuration as code default config
*/}}
{{- define "jenkins.casc.defaults" -}}
jenkins:
  {{- $configScripts := toYaml .Values.controller.JCasC.configScripts }}
  {{- if and (.Values.controller.JCasC.authorizationStrategy) (not (contains "authorizationStrategy:" $configScripts)) }}
  authorizationStrategy:
    {{- tpl .Values.controller.JCasC.authorizationStrategy . | nindent 4 }}
  {{- end }}
  {{- if and (.Values.controller.JCasC.securityRealm) (not (contains "securityRealm:" $configScripts)) }}
  securityRealm:
    {{- tpl .Values.controller.JCasC.securityRealm . | nindent 4 }}
  {{- end }}
  disableRememberMe: {{ .Values.controller.disableRememberMe }}
  remotingSecurity:
    enabled: true
  mode: {{ .Values.controller.executorMode }}
  numExecutors: {{ .Values.controller.numExecutors }}
  {{- if not (kindIs "invalid" .Values.controller.customJenkinsLabels) }}
  labelString: "{{ join " " .Values.controller.customJenkinsLabels }}"
  {{- end }}
  projectNamingStrategy: "standard"
  markupFormatter:
    {{- if .Values.controller.enableRawHtmlMarkupFormatter }}
    rawHtml:
      disableSyntaxHighlighting: true
    {{- else }}
    {{- toYaml .Values.controller.markupFormatter | nindent 4 }}
    {{- end }}
  clouds:
  - kubernetes:
      containerCapStr: "{{ .Values.agent.containerCap }}"
      defaultsProviderTemplate: "{{ .Values.agent.defaultsProviderTemplate }}"
      connectTimeout: "{{ .Values.agent.kubernetesConnectTimeout }}"
      readTimeout: "{{ .Values.agent.kubernetesReadTimeout }}"
      {{- if .Values.agent.jenkinsUrl }}
      jenkinsUrl: "{{ tpl .Values.agent.jenkinsUrl . }}"
      {{- else }}
      jenkinsUrl: "http://{{ template "jenkins.fullname" . }}.{{ template "jenkins.namespace" . }}.svc.{{.Values.clusterZone}}:{{.Values.controller.servicePort}}{{ default "" .Values.controller.jenkinsUriPrefix }}"
      {{- end }}
      {{- if not .Values.agent.websocket }}
      {{- if .Values.agent.jenkinsTunnel }}
      jenkinsTunnel: "{{ tpl .Values.agent.jenkinsTunnel . }}"
      {{- else }}
      jenkinsTunnel: "{{ template "jenkins.fullname" . }}-agent.{{ template "jenkins.namespace" . }}.svc.{{.Values.clusterZone}}:{{ .Values.controller.agentListenerPort }}"
      {{- end }}
      {{- else }}
      webSocket: true
      {{- end }}
      maxRequestsPerHostStr: {{ .Values.agent.maxRequestsPerHostStr | quote }}
      name: "{{ .Values.controller.cloudName }}"
      namespace: "{{ template "jenkins.agent.namespace" . }}"
      serverUrl: "https://kubernetes.default"
      {{- if .Values.agent.enabled }}
      podLabels:
      - key: "jenkins/{{ .Release.Name }}-{{ .Values.agent.componentName }}"
        value: "true"
      {{- range $key, $val := .Values.agent.podLabels }}
      - key: {{ $key | quote }}
        value: {{ $val | quote }}
      {{- end }}
      templates:
      {{- include "jenkins.casc.podTemplate" . | nindent 8 }}
    {{- if .Values.additionalAgents }}
      {{- /* save .Values.agent */}}
      {{- $agent := .Values.agent }}
      {{- range $name, $additionalAgent := .Values.additionalAgents }}
        {{- /* merge original .Values.agent into additional agent to ensure it at least has the default values */}}
        {{- $additionalAgent := merge $additionalAgent $agent }}
        {{- /* set .Values.agent to $additionalAgent */}}
        {{- $_ := set $.Values "agent" $additionalAgent }}
        {{- include "jenkins.casc.podTemplate" $ | nindent 8 }}
      {{- end }}
      {{- /* restore .Values.agent */}}
      {{- $_ := set .Values "agent" $agent }}
    {{- end }}
      {{- if .Values.agent.podTemplates }}
        {{- range $key, $val := .Values.agent.podTemplates }}
          {{- tpl $val $ | nindent 8 }}
        {{- end }}
      {{- end }}
      {{- end }}
  {{- if .Values.controller.csrf.defaultCrumbIssuer.enabled }}
  crumbIssuer:
    standard:
      excludeClientIPFromCrumb: {{ if .Values.controller.csrf.defaultCrumbIssuer.proxyCompatability }}true{{ else }}false{{- end }}
  {{- end }}
security:
  apiToken:
    creationOfLegacyTokenEnabled: false
    tokenGenerationOnCreationEnabled: false
    usageStatisticsEnabled: true
{{- if .Values.controller.scriptApproval }}
  scriptApproval:
    approvedSignatures:
{{- range $key, $val := .Values.controller.scriptApproval }}
    - "{{ $val }}"
{{- end }}
{{- end }}
unclassified:
  location:
    adminAddress: {{ default "" .Values.controller.jenkinsAdminEmail }}
    url: {{ template "jenkins.url" . }}
{{- end -}}

{{/*
Returns kubernetes pod template configuration as code
*/}}
{{- define "jenkins.casc.podTemplate" -}}
- name: "{{ .Values.agent.podName }}"
{{- if .Values.agent.annotations }}
  annotations:
  {{- range $key, $value := .Values.agent.annotations }}
  - key: {{ $key }}
    value: {{ $value | quote }}
  {{- end }}
{{- end }}
  id: {{ sha256sum (toYaml .Values.agent) }}
  containers:
  - name: "{{ .Values.agent.sideContainerName }}"
    alwaysPullImage: {{ .Values.agent.alwaysPullImage }}
    args: "{{ .Values.agent.args | replace "$" "^$" }}"
    command: {{ .Values.agent.command }}
    envVars:
      - envVar:
          key: "JENKINS_URL"
          {{- if .Values.agent.jenkinsUrl }}
          value: {{ tpl .Values.agent.jenkinsUrl . }}
          {{- else }}
          value: "http://{{ template "jenkins.fullname" . }}.{{ template "jenkins.namespace" . }}.svc.{{.Values.clusterZone}}:{{.Values.controller.servicePort}}{{ default "/" .Values.controller.jenkinsUriPrefix }}"
          {{- end }}
    image: "{{ .Values.agent.image }}:{{ .Values.agent.tag }}"
    privileged: "{{- if .Values.agent.privileged }}true{{- else }}false{{- end }}"
    resourceLimitCpu: {{.Values.agent.resources.limits.cpu}}
    resourceLimitMemory: {{.Values.agent.resources.limits.memory}}
    resourceRequestCpu: {{.Values.agent.resources.requests.cpu}}
    resourceRequestMemory: {{.Values.agent.resources.requests.memory}}
    runAsUser: {{ .Values.agent.runAsUser }}
    runAsGroup: {{ .Values.agent.runAsGroup }}
    ttyEnabled: {{ .Values.agent.TTYEnabled }}
    workingDir: {{ .Values.agent.workingDir }}
{{- if .Values.agent.envVars }}
  envVars:
  {{- range $index, $var := .Values.agent.envVars }}
    - envVar:
        key: {{ $var.name }}
        value: {{ tpl $var.value $ }}
  {{- end }}
{{- end }}
  idleMinutes: {{ .Values.agent.idleMinutes }}
  instanceCap: 2147483647
  {{- if .Values.agent.imagePullSecretName }}
  imagePullSecrets:
  - name: {{ .Values.agent.imagePullSecretName }}
  {{- end }}
  label: "{{ .Release.Name }}-{{ .Values.agent.componentName }} {{ .Values.agent.customJenkinsLabels  | join " " }}"
{{- if .Values.agent.nodeSelector }}
  nodeSelector:
  {{- $local := dict "first" true }}
  {{- range $key, $value := .Values.agent.nodeSelector }}
    {{- if $local.first }} {{ else }},{{ end }}
    {{- $key }}={{ tpl $value $ }}
    {{- $_ := set $local "first" false }}
  {{- end }}
{{- end }}
  nodeUsageMode: {{ quote .Values.agent.nodeUsageMode }}
  podRetention: {{ .Values.agent.podRetention }}
  showRawYaml: {{ .Values.agent.showRawYaml }}
  serviceAccount: "{{ include "jenkins.serviceAccountAgentName" . }}"
  slaveConnectTimeoutStr: "{{ .Values.agent.connectTimeout }}"
{{- if .Values.agent.volumes }}
  volumes:
  {{- range $index, $volume := .Values.agent.volumes }}
    -{{- if (eq $volume.type "ConfigMap") }} configMapVolume:
     {{- else if (eq $volume.type "EmptyDir") }} emptyDirVolume:
     {{- else if (eq $volume.type "HostPath") }} hostPathVolume:
     {{- else if (eq $volume.type "Nfs") }} nfsVolume:
     {{- else if (eq $volume.type "PVC") }} persistentVolumeClaim:
     {{- else if (eq $volume.type "Secret") }} secretVolume:
     {{- else }} {{ $volume.type }}:
     {{- end }}
    {{- range $key, $value := $volume }}
      {{- if not (eq $key "type") }}
        {{ $key }}: {{ if kindIs "string" $value }}{{ tpl $value $ | quote }}{{ else }}{{ $value }}{{ end }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}
{{- if .Values.agent.workspaceVolume }}
  workspaceVolume:
    {{- if (eq .Values.agent.workspaceVolume.type "DynamicPVC") }}
    dynamicPVC:
    {{- else if (eq .Values.agent.workspaceVolume.type "EmptyDir") }}
    emptyDirWorkspaceVolume:
    {{- else if (eq .Values.agent.workspaceVolume.type "HostPath") }}
    hostPathWorkspaceVolume:
    {{- else if (eq .Values.agent.workspaceVolume.type "Nfs") }}
    nfsWorkspaceVolume:
    {{- else if (eq .Values.agent.workspaceVolume.type "PVC") }}
    persistentVolumeClaimWorkspaceVolume:
    {{- else }}
    {{ .Values.agent.workspaceVolume.type }}:
    {{- end }}
  {{- range $key, $value := .Values.agent.workspaceVolume }}
    {{- if not (eq $key "type") }}
      {{ $key }}: {{ if kindIs "string" $value }}{{ tpl $value $ | quote }}{{ else }}{{ $value }}{{ end }}
    {{- end }}
  {{- end }}
{{- end }}
{{- if .Values.agent.yamlTemplate }}
  yaml: |-
    {{- tpl (trim .Values.agent.yamlTemplate) . | nindent 4 }}
{{- end }}
  yamlMergeStrategy: {{ .Values.agent.yamlMergeStrategy }}
{{- end -}}

{{- define "jenkins.kubernetes-version" -}}
  {{- if .Values.controller.installPlugins -}}
    {{- range .Values.controller.installPlugins -}}
      {{ if hasPrefix "kubernetes:" . }}
        {{- $split := splitList ":" . }}
        {{- printf "%s" (index $split 1 ) -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "jenkins.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "jenkins.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account for Jenkins agents to use
*/}}
{{- define "jenkins.serviceAccountAgentName" -}}
{{- if .Values.serviceAccountAgent.create -}}
    {{ default (printf "%s-%s" (include "jenkins.fullname" .) "agent") .Values.serviceAccountAgent.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccountAgent.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account for Jenkins backup to use
*/}}
{{- define "backup.serviceAccountBackupName" -}}
{{- if .Values.backup.serviceAccount.create -}}
    {{ default (printf "%s-%s" (include "jenkins.fullname" .) "backup") .Values.backup.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.backup.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create a full tag name for controller image
*/}}
{{- define "controller.tag" -}}
{{- if .Values.controller.tagLabel -}}
    {{- default (printf "%s-%s" .Chart.AppVersion .Values.controller.tagLabel) .Values.controller.tag -}}
{{- else -}}
    {{- default .Chart.AppVersion .Values.controller.tag -}}
{{- end -}}
{{- end -}}

{{/*
Create the HTTP port for interacting with the controller
*/}}
{{- define "controller.httpPort" -}}
{{- if .Values.controller.httpsKeyStore.enable -}}
    {{- .Values.controller.httpsKeyStore.httpPort -}}
{{- else -}}
    {{- .Values.controller.targetPort -}}
{{- end -}}
{{- end -}}
