data "aws_iam_policy_document" "access-hubot-parameters-policy-doc" {
  statement {
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
    ]

    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "ssm:resourceTag/project"

      values = [
        "hubot",
      ]
    }
  }

  statement {
    actions = [
      "kms:Decrypt",
    ]

    resources = [
      "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/${var.kms_key_id}",
    ]
  }
}

data "aws_iam_policy_document" "ec2-assume-role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "access-hubot-parameters-policy" {
  name        = "tf-access-hubot-parameters"
  description = "Terraform Managed. Policy to allow access to Hubot parameters"
  policy      = "${data.aws_iam_policy_document.access-hubot-parameters-policy-doc.json}"
}

resource "aws_iam_role" "access-hubot-parameters-role" {
  name               = "tf-access-hubot-parameters"
  description        = "Terraform Managed. Role to allow access to Hubot parameters"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ec2-assume-role.json}"
}

resource "aws_iam_policy_attachment" "attach-hubot-parameters-policy" {
  name       = "attach-hubot-parameters-policy"
  roles      = ["${aws_iam_role.access-hubot-parameters-role.name}"]
  policy_arn = "${aws_iam_policy.access-hubot-parameters-policy.arn}"
}

resource "aws_iam_instance_profile" "access-hubot-parameters-profile" {
  name = "tf-access-hubot-parameters"
  role = "${aws_iam_role.access-hubot-parameters-role.name}"
}
