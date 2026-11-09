# basecamp-aws

Terraform modules for an AWS landing zone: VPC, KMS, S3 logging bucket and an IAM baseline. The pieces I set up first on any new AWS account.

## Modules

| Module | What it builds |
|---|---|
| `modules/vpc` | 3-AZ VPC with three subnet tiers (public, private with NAT, intra with no route out), flow logs to CloudWatch, togglable single NAT for dev |
| `modules/kms` | Customer-managed key with alias, rotation on, 30-day deletion window |
| `modules/s3-logging` | Versioned, KMS-encrypted log bucket with lifecycle rules (STANDARD -> IA at 30d -> Glacier at 90d -> expire at 365d), public access blocked |
| `modules/iam-baseline` | Strict password policy, developers group with read-only access and permission to assume named deploy roles |

## Example

`examples/dev` wires all four modules together into a single, cheap dev environment:

```bash
cd examples/dev
terraform init
terraform plan -var bucket_name=my-org-dev-logs-$(openssl rand -hex 4)
```

## Design

- Each module owns its outputs. Nothing reads another module's `aws_*` resources directly; downstream code depends on the module output surface.
- Tagging is applied through the provider's `default_tags`, so every resource carries at least `Environment`, `ManagedBy` and `Project` without touching individual resources.
- Subnet CIDRs are computed with `cidrsubnet`, so moving from a 2-AZ to a 3-AZ setup does not renumber existing subnets.
- Flow logs go to CloudWatch, not S3, because a small CloudWatch group is cheaper to query interactively and the retention is per-group.
- KMS key rotation is on by default. The deletion window is long enough to catch a wrong `terraform destroy` while a human is still awake.

## CI

Three jobs run on every PR:

- `terraform fmt -recursive -check` and `terraform validate` against each module and the example
- `tflint` across every directory, with the default ruleset initialised
- `checkov` for security findings, `soft_fail: true` so new findings are visible without blocking PRs

Add a `terraform plan` step with real credentials by wiring GitHub Actions OIDC to an `AWS_ROLE_TO_ASSUME` secret.

## What is deliberately not here

- No EKS, RDS or application stack. Those belong in their own repositories and consume this one through `terraform_remote_state` or Terragrunt.
- No GuardDuty, Config, SecurityHub or Access Analyzer. Add them per account once the baseline is in place.
- No AWS Organizations or Control Tower setup. This repo is per-account, not per-org.
