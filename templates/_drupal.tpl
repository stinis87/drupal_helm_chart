{{/*
Return the proper Drupal image name
*/}}
{{- define "drupal.image" -}}
{{- include "kub2.image" (dict "imageRoot" .Values.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the Database Port
*/}}
{{- define "drupal.databasePort" -}}
{{- if .Values.mariadb.enabled -}}
    3306
{{- else if .Values.postgresql.enabled -}}
    5432
{{- else -}}
    3306
{{- end -}}
{{- end -}}

{{/*
Return the Database Name
*/}}
{{- define "drupal.databaseName" -}}
{{- if .Values.mariadb.enabled -}}
 {{- printf "%s" .Values.mariadb.auth.database -}}
{{- else if .Values.postgresql.enabled -}}
    {{- printf "%s" .Values.postgresql.auth.database -}}
{{- else -}}
    {{- printf "%s" .Values.mariadb.auth.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database Name
*/}}
{{- define "drupal.databaseUserName" -}}
{{- if .Values.mariadb.enabled -}}
 {{- printf "%s" .Values.mariadb.auth.username -}}
{{- else if .Values.postgresql.enabled -}}
    {{- printf "%s" .Values.postgresql.auth.username -}}
{{- else -}}
    {{- printf "%s" .Values.mariadb.auth.username -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Hostname
*/}}
{{- define "drupal.databaseHost" -}}
{{- if .Values.mariadb.enabled -}}
    {{- if eq .Values.mariadb.architecture "replication" -}}
        {{- printf "%s-%s" (include "drupal.mariadb.fullname" .) "primary" | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s" (include "drupal.mariadb.fullname" .) -}}
    {{- end -}}
{{- else if .Values.postgresql.enabled -}}
    {{- if eq .Values.postgresql.architecture "replication" -}}
        {{- printf "%s-%s" (include "drupal.postgresql.fullname" .) "primary" | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s" (include "drupal.postgresql.fullname" .) -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "drupal.mariadb.fullname" -}}
{{- printf "%s-%s" .Release.Name "mariadb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "drupal.postgresql.fullname" -}}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the Database Name
*/}}
{{- define "drupal.fullname" -}}
{{- if .Values.mariadb.enabled -}}
 {{- printf "%s" (include "drupal.mariadb.fullname" .) -}}
{{- else if .Values.postgresql.enabled -}}
   {{- printf "%s" (include "drupal.postgresql.fullname" .) -}}
{{- else -}}
    {{- printf "%s" (include "drupal.mariadb.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the database password key
*/}}
{{- define "drupal.databasePasswordKey" -}}
{{- if .Values.mariadb.enabled -}}
mariadb-password
{{- else if .Values.postgresql.enabled -}}
postgres-password
{{- else -}}
db-password
{{- end -}}
{{- end -}}

{{/*
Return  the proper Storage Class
*/}}
{{- define "drupal.storageClass" -}}
{{- include "common.storage.class" (dict "persistence" .Values.persistence "global" .Values.global) -}}
{{- end -}}

# drupal.imagePullSecrets
{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "drupal.imagePullSecrets" -}}
#{{- include "images.renderPullSecrets" ( dict "images" (list .Values.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- include "images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image .Values.certificates.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "drupal.volumePermissions.image" -}}
{{- include "images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}