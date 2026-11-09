variable "alias" {
  description = "Alias name without the alias/ prefix"
  type        = string
}

variable "description" {
  description = "Human-readable key purpose"
  type        = string
}

variable "deletion_window_in_days" {
  description = "Waiting period before a scheduled delete actually destroys the key"
  type        = number
  default     = 30
}

variable "policy" {
  description = "Override the default key policy (JSON)"
  type        = string
  default     = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
