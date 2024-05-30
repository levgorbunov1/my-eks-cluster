resource "aws_iam_openid_connect_provider" "github" {
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["C0F8253398EEDCAD8E82FF1E32E1A5AD1A0B038B"]
  url             = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_role" "cicd_role" {
  name               = "cicd_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy-document.json
}

data "aws_iam_policy_document" "assume_role_policy-document" {
  version = "2012-10-17"

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:levgorbunov1/my-webapp:*"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cicd_role_policy_document" {
  version = "2012-10-17"

  statement {
    effect  = "Allow"
    actions = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cicd_role_policy" {
  name        = "cicd_role_policy"
  policy      = data.aws_iam_policy_document.cicd_role_policy_document.json
}

resource "aws_iam_role_policy_attachment" "cicd_role_policy_attachment" {
  role       = aws_iam_role.cicd_role.name
  policy_arn = aws_iam_policy.cicd_role_policy.arn
}
