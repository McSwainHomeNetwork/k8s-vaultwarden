terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.4.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.7.1"
    }
  }
}

data "terraform_remote_state" "k8s_user_pki" {
  backend = "remote"

  count = (length(var.k8s_client_certificate) > 0 && length(var.k8s_client_key) > 0 && length(var.k8s_cluster_ca_cert) > 0) ? 0 : 1

  config = {
    organization = "McSwainHomeNetwork"
    workspaces = {
      name = "k8s-user-pki"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = var.k8s_host
    client_certificate     = length(var.k8s_client_certificate) > 0 ? var.k8s_client_certificate : data.terraform_remote_state.k8s_user_pki[0].outputs.ci_user_cert_pem
    client_key             = length(var.k8s_client_key) > 0 ? var.k8s_client_key : data.terraform_remote_state.k8s_user_pki[0].outputs.ci_user_key_pem
    cluster_ca_certificate = length(var.k8s_cluster_ca_cert) > 0 ? var.k8s_cluster_ca_cert : data.terraform_remote_state.k8s_user_pki[0].outputs.ca_cert_pem
  }
}

provider "kubernetes" {
  host                   = var.k8s_host
  client_certificate     = length(var.k8s_client_certificate) > 0 ? var.k8s_client_certificate : data.terraform_remote_state.k8s_user_pki[0].outputs.ci_user_cert_pem
  client_key             = length(var.k8s_client_key) > 0 ? var.k8s_client_key : data.terraform_remote_state.k8s_user_pki[0].outputs.ci_user_key_pem
  cluster_ca_certificate = length(var.k8s_cluster_ca_cert) > 0 ? var.k8s_cluster_ca_cert : data.terraform_remote_state.k8s_user_pki[0].outputs.ca_cert_pem
}


resource "helm_release" "vaultwarden" {
  name       = "vaultwarden"
  repository = "https://usa-reddragon.github.io/helm-charts"
  chart      = "app"
  version    = "0.1.7"
  namespace = "vaultwarden"
  create_namespace = true

  set {
    name  = "image.repository"
    value = "vaultwarden/server"
    type  = "string"
  }

  set {
    name  = "image.tag"
    value = "alpine"
    type  = "string"
  }

  set {
    name  = "ingress.hosts[0].host"
    value = "bitwarden.mcswain.dev"
    type  = "string"
  }

  set {
    name  = "ingress.hosts[0].paths[0].port"
    value = "80"
  }

  set {
    name  = "ingress.hosts[0].paths[0].path"
    value = "/"
    type  = "string"
  }

  set {
    name  = "ingress.hosts[0].paths[0].pathType"
    value = "Prefix"
    type  = "string"
  }

  set {
    name  = "ingress.hosts[0].paths[1].port"
    value = "3012"
  }

  set {
    name  = "ingress.hosts[0].paths[1].path"
    value = "/notifications/hub"
    type  = "string"
  }

  set {
    name  = "ingress.hosts[0].paths[1].pathType"
    value = "Exact"
    type  = "string"
  }

  set {
    name  = "ingress.tls[0].secretName"
    value = "bitwarden-mcswain-dev-tls"
    type  = "string"
  }

  set {
    name  = "ingress.tls[0].hosts[0]"
    value = "bitwarden.mcswain.dev"
    type  = "string"
  }

  set {
    name  = "ingress.annotations.kubernetes\\.io/ingress\\.class"
    value = "nginx"
    type  = "string"
  }

  set {
    name  = "ingress.annotations.kubernetes\\.io/tls-acme"
    value = "true"
    type  = "string"
  }

  set {
    name  = "ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = "cloudflare"
    type  = "string"
  }

  set {
    name  = "ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/ssl-redirect"
    value = "true"
    type  = "string"
  }

  set {
    name  = "probes.liveness.httpGet.path"
    value = "/"
    type  = "string"
  }

  set {
    name  = "probes.liveness.httpGet.port"
    value = "http"
    type  = "string"
  }

  set {
    name  = "probes.readiness.httpGet.path"
    value = "/"
    type  = "string"
  }

  set {
    name  = "probes.readiness.httpGet.port"
    value = "http"
    type  = "string"
  }

  set {
    name  = "service.ports[0].name"
    value = "http"
    type  = "string"
  }

  set {
    name  = "service.ports[0].port"
    value = "80"
  }
  
  set {
    name  = "service.ports[1].name"
    value = "websocket"
    type  = "string"
  }

  set {
    name  = "service.ports[1].port"
    value = "3012"
  }

  set {
    name  = "env[0].name"
    value = "SIGNUPS_ALLOWED"
    type  = "string"
  }

  set {
    name  = "env[0].value"
    value = "true"
    type  = "string"
  }

  set {
    name  = "env[1].name"
    value = "WEBSOCKET_ENABLED"
    type  = "string"
  }

  set {
    name  = "env[1].value"
    value = "true"
    type  = "string"
  }

  set {
    name  = "env[2].name"
    value = "DOMAIN"
    type  = "string"
  }

  set {
    name  = "env[2].value"
    value = "https://bitwarden.mcswain.dev"
    type  = "string"
  }

  set {
    name  = "env[3].name"
    value = "SMTP_HOST"
    type  = "string"
  }

  set {
    name  = "env[3].value"
    value = "email.mcswain.dev"
    type  = "string"
  }

  set {
    name  = "env[4].name"
    value = "SMTP_FROM"
    type  = "string"
  }

  set {
    name  = "env[4].value"
    value = "bitwarden@mcswain.dev"
    type  = "string"
  }

  set {
    name  = "env[5].name"
    value = "SMTP_PORT"
    type  = "string"
  }

  set {
    name  = "env[5].value"
    value = "465"
    type  = "string"
  }

  set {
    name  = "env[6].name"
    value = "SMTP_SSL"
    type  = "string"
  }

  set {
    name  = "env[6].value"
    value = "true"
    type  = "string"
  }
  
  set {
    name  = "env[7].name"
    value = "SMTP_EXPLICIT_TLS"
    type  = "string"
  }

  set {
    name  = "env[7].value"
    value = "true"
    type  = "string"
  }
  
  set {
    name  = "env[8].name"
    value = "SMTP_USERNAME"
    type  = "string"
  }

  set {
    name  = "env[8].value"
    value = "bitwarden"
    type  = "string"
  }

  set {
    name  = "env[9].name"
    value = "SMTP_PASSWORD"
    type  = "string"
  }

  set {
    name  = "env[9].valueFrom.secretKeyRef.name"
    value = "bitwarden-creds"
    type  = "string"
  }

  set {
    name  = "env[9].valueFrom.secretKeyRef.key"
    value = "smtp-password"
    type  = "string"
  }

  set {
    name  = "env[10].name"
    value = "DATABASE_URL"
    type  = "string"
  }

  set {
    name  = "env[10].valueFrom.secretKeyRef.name"
    value = "bitwarden-creds"
    type  = "string"
  }

  set {
    name  = "env[10].valueFrom.secretKeyRef.key"
    value = "postgresql-connection"
    type  = "string"
  }

  set {
    name  = "env[11].name"
    value = "HIBP_API_KEY"
    type  = "string"
  }

  set {
    name  = "env[11].valueFrom.secretKeyRef.name"
    value = "bitwarden-creds"
    type  = "string"
  }

  set {
    name  = "env[11].valueFrom.secretKeyRef.key"
    value = "hibp-api-key"
    type  = "string"
  }

  set {
    name  = "secrets[0].name"
    value = "bitwarden-creds"
    type  = "string"
  }

  set {
    name  = "secrets[0].data.smtp-password"
    value = var.vaultwarden_smtp_password
    type  = "string"
  }

  set {
    name  = "secrets[0].data.postgresql-connection"
    value = var.vaultwarden_postgresql_connection_string
    type  = "string"
  }

  set {
    name  = "secrets[0].data.hibp-api-key"
    value = var.vaultwarden_hibp_api_key
    type  = "string"
  }

  set {
    name  = "env[12].name"
    value = "ORG_CREATION_USERS"
    type  = "string"
  }

  set {
    name  = "env[12].value"
    value = "jacob@mcswain.dev"
    type  = "string"
  }

  set {
    name  = "env[13].name"
    value = "SIGNUPS_VERIFY"
    type  = "string"
  }

  set {
    name  = "env[13].value"
    value = "true"
    type  = "string"
  }

  set {
    name  = "env[14].name"
    value = "REQUIRE_DEVICE_EMAIL"
    type  = "string"
  }

  set {
    name  = "env[14].value"
    value = "true"
    type  = "string"
  }

  set {
    name  = "env[15].name"
    value = "LOG_LEVEL"
    type  = "string"
  }

  set {
    name  = "env[15].value"
    value = "info"
    type  = "string"
  }

}
