output "environment_endpoint" {
  value = aws_elastic_beanstalk_environment.my_todo_app_environment.endpoint_url
}

output "repository_url" {
  value = aws_ecr_repository.my_todo_app_repository.repository_url
}