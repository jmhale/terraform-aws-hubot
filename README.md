# terraform-aws-hubot

Terraform Module to deploy Hubot. This does a lot of the work to set up the necessary resources, but it still pulls down my custom Hubot code.

You can edit the user-data of hubot-instance to pull your own.

## Prerequisites
Expects that a SSM parameter with the name of `hubot-slack-token` exists and that the KMS key that the instance is using is able to decrypt that parameter.

## Variables
| Variable Name | Type | Required |Description |
|---------------|-------------|-------------|-------------|
|`private_subnet_ids`|`list`|Yes|A list of subnets for Elasticache to use. May be a single subnet, but it must be an element in a list.|
|`public_subnet_ids`|`list`|Yes|A list of subnets for the Autoscaling Group to use for launching instances. May be a single subnet, but it must be an element in a list.|
|`ssh_key_id`|`string`|Yes|A SSH public key ID to add to the VPN instance.|
|`vpc_id`|`string`|Yes|The VPC ID in which Terraform will launch the resources.|
|`ingress_security_group_id`|`string`|Yes|The ID of the Security Group to allow SSH access from.|
|`kms_key_id`|`string`|Yes|The KMS key ID to give Hubot access to for decrypting secrets.|
|`ami_id`|`string`|No. Defaults to Ubuntu 16.04 AMI in us-east-1|The AMI ID to use.|


## Usage
```
module "terraform-hubot" {
  source                    = "git@github.com:jmhale/terraform-hubot.git"
  ssh_key_id                = "ssh-keypair-name-example"
  vpc_id                    = "vpc-0123456"
  public_subnet_ids         = ["subnet-1234567", "subnet-0987654"]
  private_subnet_ids        = ["subnet-abcdefg", "subnet-zyxwvu"]
  ingress_security_group_id = "sg-1234567"
}
```

## Outputs
None

## To do
- Put KMS-encrypted value of SSM parameter into this module so that it's existence is not a prereq.

---
Copyright © 2019, James Hale
