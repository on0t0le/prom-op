{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "elasticsearch.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.fullname" -}}
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
Create a default fully qualified node name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.esNode.fullname" -}}
{{ template "elasticsearch.fullname" . }}
{{- end -}}

{{/*
Create the name of the service account to use for the ES node
*/}}
{{- define "elasticsearch.serviceAccountName.esNode" -}}
{{- if .Values.serviceAccounts.esNode.create -}}
    {{ default (include "elasticsearch.esNode.fullname" .) .Values.serviceAccounts.esNode.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.esNode.name }}
{{- end -}}
{{- end -}}

{{/*
plugin installer template
*/}}
{{- define "plugin-installer" -}}
- name: es-plugin-install
  image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  securityContext:
    capabilities:
      add:
        - IPC_LOCK
        - SYS_RESOURCE
  command:
    - "sh"
    - "-c"
    - |
      {{- range .Values.cluster.plugins }}
      /usr/share/elasticsearch/bin/elasticsearch-plugin install -b {{ . }}
      {{- end }}
  volumeMounts:
  - mountPath: /usr/share/elasticsearch/plugins/
    name: plugindir
  - mountPath: /usr/share/elasticsearch/config/elasticsearch.yml
    name: config
    subPath: elasticsearch.yml
{{- end -}}
