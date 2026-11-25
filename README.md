# PagerDuty Webhooks Migration Demo (v2 to v3) with Terraform

This repository demonstrates how to migrate PagerDuty webhooks from **Generic Webhooks v2 (`pagerduty_extension`)** to **Webhook Subscriptions v3 (`pagerduty_webhook_subscription`)** using Terraform.

The workflow is designed for a live demonstration: it first provisions the legacy **v2** webhooks and then transitions to **v3** by swapping the configuration files, allowing Terraform to automatically create the v3 subscriptions while destroying the v2 extensions in a single apply.

## 📋 Prerequisites

Before running this demo, make sure you have:

* [Terraform](https://hashicorp.com) `>= 1.0.0`
* [Official PagerDuty Provider](https://terraform.io) `~> 3.0`
* A **PagerDuty API Key** with write permissions (`Full Access` or permissions to manage *Services*, *Extensions*, and *Webhook Subscriptions*).
* Existing PagerDuty services named **`AActions`** and **`Urbina`** in your target PagerDuty account.

## ⚙️ Configuration & Variables

All sensitive input values are supplied via a `terraform.tfvars` file (excluded from version control via `.gitignore` for security). A little exceptions are the url webhooks on main.tf that you need to set manually.

1. Clone this repository:
   ```bash
   git clone https://github.com
   cd your-repo
   ```

2. Create a `terraform.tfvars` file in the root directory with the following variables:
   ```hcl
   pagerduty_token       = "your_pagerduty_api_token"
   oficina_header_andres = "your_secret_header_value_for_andres"
   oficina_header_new    = "your_secret_header_value_for_new"
   ```

### Input Variables (`variables.tf`)

| Variable | Description | Type | Sensitive | Required |
| :--- | :--- | :---: | :---: | :---: |
| `pagerduty_token` | PagerDuty API token with write permissions | `string` | Yes | Yes |
| `oficina_header_andres` | Secret value for the `Oficina` custom header in `AndresWebhook` | `string` | Yes | Yes |
| `oficina_header_new` | Secret value for the `Oficina` custom header in `NEWwebhook` | `string` | Yes | Yes |

## 🚀 Demo & Migration Workflow

### Phase 1: Deploy Generic Webhooks (v2)

Initially, `main.tf` contains the configuration for the **v2** webhooks (`WebhookActionService`, `AndresWebhook`, and `NEWwebhook`).

1. **Initialize the working directory** and download the PagerDuty provider:
   ```bash
   terraform init
   ```

2. **Preview the execution plan** to verify the three `pagerduty_extension` (v2) resources to be created:
   ```bash
   terraform plan
   ```

3. **Create the v2 webhooks**:
   ```bash
   terraform apply
   ```
   *(Confirm with `yes` when prompted. You can now verify the active v2 extensions in your PagerDuty account.)*

---

### Phase 2: Migrate to Webhook Subscriptions (v3)

To perform the migration, swap the active `main.tf` file with the pre-configured v3 template (`main.V3`). Because Terraform tracks state across runs, renaming the files instructs Terraform to replace the old v2 extensions with the new v3 subscriptions.

1. **Archive the v2 file and activate the v3 configuration**:
   ```bash
   mv main.tf main.V2
   mv main.V3 main.tf
   ```

2. **Preview the migration plan**:
   ```bash
   terraform plan
   ```
   *(Terraform will show **3 to add** (`pagerduty_webhook_subscription`) and **3 to destroy** (`pagerduty_extension`).)*

3. **Execute the migration**:
   ```bash
   terraform apply
   ```
   *(Confirm with `yes`. Terraform will provision the new v3 webhook subscriptions—including all 12 incident event triggers and custom headers—and remove the legacy v2 webhooks.)*

## 📁 Project Structure

```text
.
├── main.tf            # Active Terraform configuration (starts as v2, replaced by v3 during migration)
├── main.V3            # Pre-configured Webhook Subscriptions v3 definitions (renamed to main.tf in Phase 2)
├── variables.tf       # Input variable declarations (marked as sensitive)
├── terraform.tfvars   # Local file containing secret variable values (not tracked in Git)
└── README.md          # Project documentation
```

## 🔄 Resetting the Demo

If you want to run the demonstration again from scratch:

```bash
terraform destroy
mv main.tf main.V3
mv main.V2 main.tf
```
