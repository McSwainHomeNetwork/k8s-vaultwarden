variable "k8s_host" {
  type        = string
  description = "Address of the k8s host."
  sensitive   = true
}

variable "k8s_client_key" {
  type        = string
  default     = ""
  description = "Private key by which to auth with the k8s host."
  sensitive   = true
}

variable "k8s_cluster_ca_cert" {
  type        = string
  default     = ""
  description = "CA cert of the k8s host."
  sensitive   = true
}

variable "k8s_client_certificate" {
  type        = string
  default     = ""
  description = "CA cert of the k8s host."
  sensitive   = true
}

variable "vaultwarden_smtp_password" {
  type        = string
  description = "VaultWarden SMTP Password"
  sensitive   = true
}

variable "vaultwarden_postgresql_connection_string" {
  type        = string
  description = "VaultWarden PostgreSQL Connection String in the format `postgresql://[[user]:[password]@]host[:port][/database]`"
  sensitive   = true
}

variable "vaultwarden_hibp_api_key" {
  type        = string
  description = "VaultWarden HaveIBeenPwned API Key"
  sensitive   = true
}