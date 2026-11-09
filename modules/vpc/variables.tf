variable "name" {
  description = "Prefix used for every resource name and tag"
  type        = string
}

variable "cidr" {
  description = "VPC CIDR block, /16 recommended"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "How many AZs to spread subnets across (2 or 3)"
  type        = number
  default     = 3
  validation {
    condition     = var.az_count >= 2 && var.az_count <= 3
    error_message = "az_count must be 2 or 3."
  }
}

variable "single_nat_gateway" {
  description = "Use one NAT gateway for all AZs (cheap for dev, SPOF for prod)"
  type        = bool
  default     = false
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs to CloudWatch"
  type        = bool
  default     = true
}

variable "flow_log_retention_days" {
  description = "CloudWatch log group retention in days"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Extra tags applied to every resource"
  type        = map(string)
  default     = {}
}
