variable "pagerduty_token" {
  description = "Api token read permission"
  type        = string
  sensitive   = true
}

variable "oficina_header_andres" {
  description = "Custom header value AndresWebhook"
  type        = string
  sensitive   = true
}

variable "oficina_header_new" {
  description = "Customer header value NEWwebhook"
  type        = string
  sensitive   = true
}
