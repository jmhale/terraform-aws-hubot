# terraform-hubot

Terraform Module to deploy Hubot. This does a lot of the work to set up the necessary resources, but it still pulls down my custom Hubot code.

You can edit the user-data of hubot-instance to pull your own.

## Prerequsities
Expects that a SSM parameter with the name of `hubot-slack-token` exists and that the KMS key that the instance is using is able to decrypt that parameter.

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

## To do
- Put KMS-encrypted value of SSM parameter into this module so that it's existence is not a prereq.

---
Copyright © 2019, James Hale
