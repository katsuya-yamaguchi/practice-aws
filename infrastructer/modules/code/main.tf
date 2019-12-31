#resource "aws_iam_policy" "codepipeline" {
#  name   = "${var.func_name_registerSqs}"
#  path   = "/"
#  policy = "${file("${path.module}/codepipeline_policy.json")}"
#}

resource "aws_codecommit_repository" "practice" {
  repository_name = "practice"
  description     = "practice"
}

resource "aws_codedeploy_app" "practice" {
  compute_platform = "Server"
  name             = "practice"
}

resource "aws_iam_role" "codedeploy" {
  name               = "practice-codedeploy"
  path               = "/"
  assume_role_policy = "${file("${path.module}/codedeploy_policy.json")}"
}

resource "aws_codedeploy_deployment_group" "practice" {
  app_name              = "${aws_codedeploy_app.practice.name}"
  deployment_group_name = "practice01"
  service_role_arn      = "${aws_iam_role.codedeploy.arn}"

  ec2_tag_set {
    ec2_tag_filter {
      type  = "KEY_AND_VALUE"
      key   = "Name"
      value = "practice_01"
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  alarm_configuration {
    alarms  = ["practice"]
    enabled = true
  }
}

#resource "aws_code_pipeline" "codepipeline" {
#  name = "practice"
#  role = "${aws_iam_policy.codepipeline.id}"
#
#  stage {
#    name = "Source"
#
#    action {
#      name     = "Source"
#      category = "Source"
#      owner    = "AWS"
#      provider = "CodeCommit"
#      version = "1"
#
#      configuration = {
#        RepositoryName = "practice"
#        BranchName = "master"
#      }
#    }
#  }
#
#  stage {
#    name = "Deploy"
#
#    action {
#      name = "Deploy"
#      category = "Deploy"
#      owner = "AWS"
#    }
#  }
#}
