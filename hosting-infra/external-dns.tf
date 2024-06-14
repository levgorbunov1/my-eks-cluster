resource "aws_iam_role" "external_dns_role" {
  name = "external-dns-role"
  assume_role_policy = data.aws_iam_policy_document.external_dns_assume_role_policy.json
}

data "aws_iam_policy_document" "external_dns_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.cluster_oidc_provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:external-dns"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.cluster_oidc_provider.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_policy" "external_dns_iam_policy" {
  name   = "ExternalDNSIAMPolicy"
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets",
        "route53:ListTagsForResource"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
)
}

resource "aws_iam_role_policy_attachment" "external_dns_iam_policy_attachment" {
  policy_arn = aws_iam_policy.external_dns_iam_policy.arn
  role       = aws_iam_role.external_dns_role.name
}