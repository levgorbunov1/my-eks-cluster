resource "aws_iam_role" "csi_driver_service_account_role" {
  name = "csi-driver-role"
  assume_role_policy = data.aws_iam_policy_document.csi_driver_assume_role_policy.json
}

data "aws_iam_policy_document" "csi_driver_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.cluster_oidc_provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:csi-driver"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.cluster_oidc_provider.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_policy" "ebs_csi_driver_kms_policy" {
  name = "EBS-CSI-KMS-Policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "kms:CreateGrant",
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "arn:aws:kms:eu-west-2:368155700659:key/*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "csi_driver_iam_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.csi_driver_service_account_role.name
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_kms_policy_attachment" {
  policy_arn = aws_iam_policy.ebs_csi_driver_kms_policy.arn
  role       = aws_iam_role.csi_driver_service_account_role.name
}
