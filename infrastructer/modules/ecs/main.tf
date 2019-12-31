resource "aws_cloudwatch_log_group" "sample_app" {
  name              = "sample-app"
  retention_in_days = 1

  tags = {
    Name = "sample-app"
  }
}

resource "aws_ecs_cluster" "cluster" {
  name = "practice"

  tags = {
    Name = "practice"
  }
}

resource "aws_ecs_task_definition" "sample_app" {
  family                   = ""
  container_definitions    = "${file("../modules/ecs/task_definition/sample-app.json")}"
  requires_compatibilities = "EC2"
  network_mode             = "bridge"

  tags = {
    Name = "sample_app"
  }
}

resource "aws_ecs_service" "sample_app" {
  name            = "sample-app"
  cluster         = "${aws_ecs_cluster.cluster.id}"
  task_definition = "${aws_ecs_task_definition.sample_app.id}"
  launch_type     = "EC2"
  desired_count   = 3
  # 半分ずつローリングアップデートする
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 50
  iam_role                           = ""
  # サービスが起動してヘルスチェックに応答するのを無視する時間
  health_check_grace_period_seconds = 60
  # ローリングアップデート
  deployment_controller = "ECS"
  # クラスター全体で必要数のタスクを配置して維持する
  scheduling_strategy = "REPLICA"

  ordered_placement_strategy {
    type = "spread"
    # 全てのインスタンス間でタスクを均等に分散する
    field = "instanceId"
  }

  load_balancer {
    target_group_arn = ""
    container_name   = ""
    container_port   = ""
  }

  tags = {
    Name = "sample-app"
  }
}

# ECS Serviceにassumeroleする
resource "aws_iam_role" "ecs_service_role" {
  name               = "ecs_sesrvice_role"
  assume_role_policy = "${file("../modules/ecs/iam/ecs_assume_role.json")}"
}

resource "aws_iam_policy_attachment" "ecs_service_role_attachment" {
  name = "ecs-service-role-attach"
  role = ["${aws_iam_role.ecs_service_role.name}"]
  # ELBがEC2コンテナインスタンスを登録 or 登録解除を許可するロール
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}
