# Terraform Infrastructure as Code

Expert guidance for writing, reviewing, and maintaining Terraform configurations.

## Core Principles

- **Idempotent:** Running `terraform apply` twice produces the same result
- **Immutable infrastructure:** Replace, don't modify in place
- **Least privilege:** IAM roles/policies grant only what's needed
- **State is truth:** Never manually change cloud resources that Terraform manages

## Module Structure

```
modules/
  <module-name>/
    main.tf          # Core resources
    variables.tf     # Input variables with descriptions and types
    outputs.tf       # Output values
    versions.tf      # Required providers and versions
    README.md        # Usage examples

environments/
  dev/
    main.tf
    terraform.tfvars
  staging/
    main.tf
    terraform.tfvars
  prod/
    main.tf
    terraform.tfvars
```

## Writing Best Practices

### Variables
```hcl
variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}
```

### Outputs
```hcl
output "database_url" {
  description = "PostgreSQL connection string"
  value       = "postgresql://${aws_db_instance.main.endpoint}/${var.db_name}"
  sensitive   = true  # mask in logs
}
```

### Resource Naming
```hcl
locals {
  name_prefix = "${var.project}-${var.environment}"
}

resource "aws_s3_bucket" "main" {
  bucket = "${local.name_prefix}-assets"
}
```

## Workflow

```bash
# Initialize
terraform init

# Format
terraform fmt -recursive

# Validate
terraform validate

# Plan (always before apply)
terraform plan -out=tfplan

# Review plan, then apply
terraform apply tfplan

# Destroy (careful!)
terraform destroy -target=<resource>
```

## Review Checklist

- [ ] No hardcoded credentials or secrets — use `var.*` or data sources
- [ ] Sensitive outputs marked `sensitive = true`
- [ ] Resources tagged with `environment`, `project`, `owner`
- [ ] State stored remotely (S3 + DynamoDB lock, Terraform Cloud)
- [ ] Modules pinned to specific versions (`source = "hashicorp/vpc" version = "~> 3.0"`)
- [ ] `prevent_destroy = true` on stateful resources (databases, S3 buckets)
- [ ] `lifecycle { ignore_changes }` documented where used

## Common Anti-patterns

- Hardcoding region or account IDs — use variables or data sources
- Putting everything in one `main.tf` — split by resource type
- Not locking provider versions — use `required_providers` with version constraints
- Modifying state manually — always use `terraform import` or `terraform state mv`

## Source

[VoltAgent/awesome-agent-skills — HashiCorp Terraform](https://github.com/VoltAgent/awesome-agent-skills)
