terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.40.0" }
  }
}

# Account-wide IAM baseline: strong password policy, no root access keys, and
# a developer group that can log in and assume a named deploy role.

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 14
  require_lowercase_characters   = true
  require_uppercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true
  max_password_age               = 90
  password_reuse_prevention      = 10
}

resource "aws_iam_group" "developers" {
  name = "developers"
}

data "aws_iam_policy_document" "assume_deploy" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = [for a in var.deploy_role_arns : a]
  }
}

resource "aws_iam_policy" "assume_deploy" {
  name        = "AssumeDeployRoles"
  description = "Allow members of the developers group to assume named deploy roles"
  policy      = data.aws_iam_policy_document.assume_deploy.json
}

resource "aws_iam_group_policy_attachment" "developers_assume_deploy" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.assume_deploy.arn
}

# Minimal read-only policy so developers can see the console without
# AdministratorAccess. Narrow in anger.
resource "aws_iam_group_policy_attachment" "developers_read" {
  group      = aws_iam_group.developers.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
