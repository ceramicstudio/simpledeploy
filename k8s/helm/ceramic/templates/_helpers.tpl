{{/*
Expand the name of the chart.
*/}}
{{- define "ceramic.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "ceramic.ipfs.name" -}}
{{- printf "%s-ipfs" (include "ceramic.name" .) | trunc 63 -}}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ceramic.fullname" -}}
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

{{- define "ceramic.ipfs.fullname" -}}
{{- printf "%s-ipfs" (include "ceramic.fullname" .) | trunc 63 -}}
{{- end -}}
{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ceramic.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ceramic.labels" -}}
helm.sh/chart: {{ include "ceramic.chart" . }}
{{ include "ceramic.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ceramic.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ceramic.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common IPFS labels
*/}}
{{- define "ceramic.ipfs.labels" -}}
helm.sh/chart: {{ include "ceramic.chart" . }}
{{ include "ceramic.ipfs.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector IPFS labels
*/}}
{{- define "ceramic.ipfs.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ceramic.ipfs.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ceramic.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ceramic.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


