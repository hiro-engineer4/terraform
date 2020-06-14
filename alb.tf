# SecurityGroup
resource "aws_security_group" "alb" {
  name        = "${var.name}-alb"
  description = "${var.name} alb"
  vpc_id      = "${aws_vpc.main.id}"

  # セキュリティグループ内のリソースからインターネットへのアクセスを許可する
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-alb"
  }
}

# SecurityGroup Rule
resource "aws_security_group_rule" "alb_http" {
  security_group_id = "${aws_security_group.alb.id}"

  # セキュリティグループ内のリソースへインターネットからのアクセスを許可する
  type = "ingress"

  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

# ALB
resource "aws_lb" "main" {
  load_balancer_type = "application"
  name               = "${var.name}"

  security_groups = ["${aws_security_group.alb.id}"]
  subnets         = ["${aws_subnet.public_1a.id}", "${aws_subnet.public_1c.id}", "${aws_subnet.public_1d.id}"]
}

# Listener
resource "aws_lb_listener" "main" {
  # HTTPでのアクセスを受け付ける
  port              = "80"
  protocol          = "HTTP"

  # ALBのarnを指定します。
  #XXX: arnはAmazon Resource Names の略で、その名の通りリソースを特定するための一意な名前(id)です。
  load_balancer_arn = "${aws_lb.main.arn}"

  # "ok" という固定レスポンスを設定する
  default_action {
    type             = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "ok"
    }
  }
}
