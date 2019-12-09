#resource "aws_iam_policy" "codepipeline" {
#  name   = "${var.func_name_registerSqs}"
#  path   = "/"
#  policy = "${file("${path.module}/codepipeline_policy.json")}"
#}

resource "aws_codecommit_repository" "practice" {
  repository_name = "practice"
  description = "practice"
}

#resource "aws_codedeploy_app" "practice" {
#  compute_platform = "Server"
#  name = "practice"
#}
#
#
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
