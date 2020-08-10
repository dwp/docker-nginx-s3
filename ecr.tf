resource "aws_ecr_repository" "docker-nginx-s3" {
  name = "nginx-s3"
  tags = merge(
    local.common_tags,
    { DockerHub : "dwpdigital/nginx-s3" }
  )
}

resource "aws_ecr_repository_policy" "docker-nginx-s3" {
  repository = aws_ecr_repository.docker-nginx-s3.name
  policy     = data.terraform_remote_state.management.outputs.ecr_iam_policy_document
}

output "ecr_example_url" {
  value = aws_ecr_repository.docker-nginx-s3.repository_url
}
