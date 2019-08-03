variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "ssh_key_id" {
}

variable "vpc_id" {
}

variable "ingress_security_group_id" {
}

variable "kms_key_id" {
}

variable "ami_id" {
  default = "ami-da05a4a0"
}

