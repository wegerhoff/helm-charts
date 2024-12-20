{{/*
Expand the name of the chart.
*/}}
{{- define "kubevirt-manager.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kubevirt-manager.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kubevirt-manager.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kubevirt-manager.labels" -}}
helm.sh/chart: {{ include "kubevirt-manager.chart" . }}
{{ include "kubevirt-manager.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kubevirt-manager.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kubevirt-manager.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "kubevirt-manager.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "kubevirt-manager.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the clusterrole for the cas management
*/}}
{{- define "kubevirt-manager.clusterRole.cas-management" -}}
{{- printf "%s-%s" (include "kubevirt-manager.fullname" .) "cas-management" | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create the name of the clusterrole for the cas workload
*/}}
{{- define "kubevirt-manager.clusterRole.cas-workload" -}}
{{- printf "%s-%s" (include "kubevirt-manager.fullname" .) "cas-workload" | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create the name of the clusterrole for the kccm
*/}}
{{- define "kubevirt-manager.clusterRole.kccm" -}}
{{- printf "%s-%s" (include "kubevirt-manager.fullname" .) "kccm" | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Get the name of the secret containing the information for basic authentication
*/}}
{{- define "kubevirt-manager.ingress.basicAuth.secretName" -}}
  {{- if .Values.ingress.basicAuth.existingSecret -}}
    {{- printf "%s" (tpl .Values.ingress.basicAuth.existingSecret $) -}}
  {{- else -}}
      {{- printf "%s" (include "kubevirt-manager.fullname" .) -}}
  {{- end -}}
{{- end -}}
