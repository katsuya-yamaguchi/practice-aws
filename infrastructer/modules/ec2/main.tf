variable "ecs_cluster" {}
variable "az_a" {}
variable "az_c" {}
variable "sg_internal" {}



resource "aws_key_pair" "sample_app" {
  key_name   = "sample-app"
  public_key = "${file("./ec2/key_pair/sample-app.pub")}"
}

resource "aws_launch_configuration" "sample_app" {
  name                        = "sample-app"

  # ECS-optimized Amazon Linux 2 AMI
  image_id                    = "ami-0934e28fe3e390537"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.sample_app.key_name}"
  security_groups             = ["${var.sg_internal}"]

  # EIPは付与しない
  associate_public_ip_address = 0

  # ECSクラスタに登録する
  user_data                   = <<EOF
    #!/bin/bash
    echo ECS_CLUSTER=${var.ecs_cluster}
  EOF


  lifecycle {
    # 削除する前に作成する
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "sample_app" {
  name                      = "sample-app"
  max_size                  = 4
  min_size                  = 1
  desired_capacity          = 1
  # インスタンスが起動してからヘルスチェックをするまでの時間
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.sample_app.id}"
  vpc_zone_identifier       = ["${var.az_a}", "${var.az_c}"]
  load_balancers            = ["${aws_elb.sample_app.name}"]

  tag = {
    key                 = "Name"
    name                = "sample-app-asg"
    # ASGを通して起動したEC2にタグを伝搬する
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "sample-app-scale-out"
  # 指定した値だけ既存の値から増減させる
  adjustment_type        = "ChangeInCapacity"
  # スケールさせる数
  scaling_adjustment     = 1
  # 次のスケールが開始するまでの時間
  cooldown               = 60
  autoscaling_group_name = "${aws_autoscaling_group.sample_app.name}"
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "sample-app-scale-in"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 60
  autoscaling_group_name = "${aws_autoscaling_group.sample_app.name}"
}

resource "aws_cloudwatch_metrics_alarm" "sample_app_high" {
  alarm_name          = "sample-app-cpu-usage-exceeds-40"
  # 閾値と比較する方法
  comparison_operator = "GreaterThanOrEqualToThreshold"
  # アラームの状態を決定するまでの直近のデータポイントの数
  evaluation_periods  = "1"
  # データを取得する秒単位の期間
  period              = "60"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  # メトリクスに適用する統計方法
  statistic           = "Average"
  threshold           = "40"
  # メトリクスを一意に識別する名称
  dimentions = {
    AutoScalingGroupName = "${aws_autoscaling_group.sample_app.name}"
  }
  alarm_actions = ["${aws_autoscaling_policy.scale_out.arn}"]
}

resource "aws_cloudwatch_metrics_alarm" "sample_app_low" {
  alarm_name          = "sample-app-cpu-usage-less-than-40"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "30"
  dimention {
    AutoScalingGroupName = "${aws_autoscaling_group.sample_app.name}"
  }
  alarm_actions = ["${aws_autoscaling_policy.scale_in.arn}"]
}

resource "aws_lb" "sample_app" {
  name = "sample-app-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [""]
  subnets = [""]
  enable_deletion_protection = true

  tags = {
    Name = "sample-app-alb"
  }
}
