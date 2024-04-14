resource "aws_ecr_repository" "my_todo_app_repository" {
  name         = "todo-app"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_caller_identity" "current" {}

resource "null_resource" "docker_packaging" {

  provisioner "local-exec" {
    command = <<-EOF
	    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com
	    EOF
  }
  provisioner "local-exec" {
    command = <<-EOF
	    docker build -t todo-app .
	    EOF
  }
  provisioner "local-exec" {
    command = <<-EOF
	    docker tag todo-app:latest ${aws_ecr_repository.my_todo_app_repository.repository_url}:latest 
	    EOF
  }
  provisioner "local-exec" {
    command = <<-EOF
	    docker push ${aws_ecr_repository.my_todo_app_repository.repository_url}:latest
	    EOF
  }

  depends_on = [
    aws_ecr_repository.my_todo_app_repository
  ]

}