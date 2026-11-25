terraform {
  required_version = ">= 1.0.0"

  required_providers {
    pagerduty = {
      source  = "PagerDuty/pagerduty"
      version = "~> 3.0"
    }
  }
}

provider "pagerduty" {
  token = var.pagerduty_token
}

# Obtener dinámicamente el esquema de "Generic V2 Webhook"
data "pagerduty_extension_schema" "webhook" {
  name = "Generic V2 Webhook"
}

# Obtener los IDs de tus servicios existentes
data "pagerduty_service" "aactions" {
  name = "AActions"
}

data "pagerduty_service" "urbina" {
  name = "Urbina"
}

# 1. Webhook: WebhookActionService
resource "pagerduty_extension" "webhook_action_service" {
  name              = "WebhookActionService"
  endpoint_url      = "https://your_saas_endpoint.cloud/api/61/webhook/a40tdTq1jacxbJyMgXc3Lwi4rEUNn7Ch#RBAAndresWebhook"
  extension_schema  = data.pagerduty_extension_schema.webhook.id
  extension_objects = [data.pagerduty_service.aactions.id]
}

# 2. Webhook: AndresWebhook
resource "pagerduty_extension" "andres_webhook" {
  name              = "AndresWebhook"
  endpoint_url      = "https://your_saas_endpoint.cloud/api/61/webhook/vQ1tdTq1jacxbJyMgXc3Lwi4rEUNn7Ch#RBAAndresWebhook"
  extension_schema  = data.pagerduty_extension_schema.webhook.id
  extension_objects = [data.pagerduty_service.urbina.id]

  config = jsonencode({
    headers = [
      {
        name  = "Office"
        value = var.office_header_andres
      }
    ]
  })
}

# 3. Webhook: NEWwebhook
resource "pagerduty_extension" "new_webhook" {
  name              = "NEWwebhook"
  endpoint_url      = "https://your_saas_endpoint.cloud/api/61/webhook/iuy1wX4e9zDS6eaUNmwjrUAGfevXwaUz#PdWebhookTest"
  extension_schema  = data.pagerduty_extension_schema.webhook.id
  extension_objects = [data.pagerduty_service.urbina.id]

  config = jsonencode({
    headers = [
      {
        name  = "Oficina"
        value = var.office_header_new
      }
    ]
  })
}
