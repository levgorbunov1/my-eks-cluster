resource "aws_iam_role" "cert_manager_role" {
  name = "cert-manager-role"
  assume_role_policy = data.aws_iam_policy_document.cert_manager_assume_role_policy.json
}

data "aws_iam_policy_document" "cert_manager_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.cluster_oidc_provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:cert-manager:cert-manager"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.cluster_oidc_provider.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_policy" "cert_manager_iam_policy" {
  name   = "CertManagerIAMPolicy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "acm:RequestCertificate",
                "acm:DescribeCertificate",
                "acm:ListCertificates",
                "acm:GetCertificate",
                "route53:GetChange",
                "route53:ChangeResourceRecordSets",
                "route53:ListResourceRecordSets",
                "route53:ListHostedZonesByName"
            ],
            "Resource": "*"
        }
    ]
}
)
}

resource "aws_iam_role_policy_attachment" "cert_manager_iam_policy_attachment" {
  policy_arn = aws_iam_policy.cert_manager_iam_policy.arn
  role       = aws_iam_role.cert_manager_role.name
}