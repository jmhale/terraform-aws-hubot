variable "private_subnet_ids" {
  type = "list"
}

variable "public_subnet_ids" {
  type = "list"
}

variable "ssh_key_id" {}

variable "vpc_id" {}

variable "ingress_security_group_id" {}

variable "kms_key_id" {}
