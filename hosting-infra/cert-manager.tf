resource "aws_iam_role" "cert_manager_role" {
  name = "cert-manager-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
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
                "acm:GetCertificate"
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