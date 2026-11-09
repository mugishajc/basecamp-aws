variable "deploy_role_arns" {
  description = "Deploy role ARNs that the developers group may assume"
  type        = list(string)
  default     = []
}
