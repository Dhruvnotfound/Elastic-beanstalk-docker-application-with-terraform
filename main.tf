resource "aws_elastic_beanstalk_application" "my_todo_app" {
  name        = "my-todo-app"
  description = "My Todo Application"

  appversion_lifecycle {
    service_role          = aws_iam_role.ng_beanstalk_ec2.arn
    delete_source_from_s3 = true
  }
}

resource "aws_s3_bucket" "dockerrun" {
  bucket        = "todolistapplicationversion"
  force_destroy = true
}

data "archive_file" "dockerrun_archive" {
  type        = "zip"
  source_file = "Dockerrun.aws.json"
  output_path = "dockerrun.zip"
}

resource "aws_s3_object" "dockerrun_zip" {
  bucket = aws_s3_bucket.dockerrun.id
  key    = "dockerrun.zip"
  source = "${data.archive_file.dockerrun_archive.output_path}"
}

resource "aws_elastic_beanstalk_application_version" "my_app_version" {
  name        = "todo-test-version-1"
  application = "${aws_elastic_beanstalk_application.my_todo_app.name}"
  description = "application version created by terraform"
  bucket = aws_s3_bucket.dockerrun.bucket
  key    = aws_s3_object.dockerrun_zip.key
}

resource "aws_elastic_beanstalk_environment" "my_todo_app_environment" {
  name                = "my-todo-app-environment"
  application         = aws_elastic_beanstalk_application.my_todo_app.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.3.0 running Docker"
  version_label = aws_elastic_beanstalk_application_version.my_app_version.name

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.ng_beanstalk_ec2.arn
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.ng_beanstalk_ec2.name
  }

  depends_on = [null_resource.docker_packaging]
}

