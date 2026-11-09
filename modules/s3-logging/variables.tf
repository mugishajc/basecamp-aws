variable "bucket_name" {
  description = "Globally unique bucket name"
  type        = string
}

variable "kms_key_arn" {
  description = "ARN of the KMS key used for bucket encryption"
  type        = string
}

variable "expiration_days" {
  description = "How many days before current versions are expired"
  type        = number
  default     = 365
}

variable "force_destroy" {
  description = "Allow terraform destroy to wipe the bucket even if not empty"
  type        = bool
  default     = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
