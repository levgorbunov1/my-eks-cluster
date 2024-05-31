resource "aws_ecr_repository" "webapp_ecr" {
  name                 = "webapp_ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}