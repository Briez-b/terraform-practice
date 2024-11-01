# Define launch template and autoscaling group

resource "aws_launch_template" "lt" {
  name_prefix = "terrVPC-lt"
  image_id = var.lt-image-id
  instance_type = var.lt-instance-type
  key_name = var.lt-key-name
  vpc_security_group_ids = [var.sg-id]
  user_data = base64encode(file(var.lt-script-path))
}

resource "aws_autoscaling_group" "as" {
  name = "terrVPC-as"
  max_size = var.as-max
  min_size = var.as-min
  desired_capacity = var.as-desired
  vpc_zone_identifier = [var.prv-sub1-id, var.prv-sub2-id]
  target_group_arns = [var.tg-arn]

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ASG Private Instance"
    propagate_at_launch = true
  }

}