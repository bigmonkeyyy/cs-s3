# Getting data for already created resources
data "aws_security_group" "external-lb-sg" {
  filter {
    name  = "tag:For"
    values = ["external-lb"]
  }
}

data "aws_security_group" "internal-lb-sg" {
  filter {
    name  = "tag:For"
    values = ["internal-lb"]
  }
}

data "aws_security_group" "frontend-servers-sg" {
  filter {
    name  = "tag:For"
    values = ["frontend-app"]
  }
}

data "aws_security_group" "backend-servers-sg" {
  filter {
    name  = "tag:For"
    values = ["backend-app"]
  }
}

# Frontend
resource "aws_lb" "frontend-lb" {
  name               = "frontend-${var.client}"
  security_groups    = [data.aws_security_group.external-lb-sg.id]
  subnet_mapping {
    subnet_id        = aws_subnet.frontend-az1.id
  }
  subnet_mapping {
    subnet_id        = aws_subnet.frontend-az2.id
  }
}

resource "aws_lb_target_group" "frontend-tg" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.frontned_vpc_id
}

resource "aws_launch_template" "frontend" {
  name                   = "frontend"
  image_id               = var.images[var.aws_region]
  instance_type          = var.server_type
  key_name               = var.key_name
  vpc_security_group_ids = [data.aws_security_group.frontend-servers-sg.id]  
  user_data = filebase64("/mnt/c/Link/exec/cs/user_data/frontend_${var.frontend_server}.sh")
  # Placeholder for CICD pipelines configuration
  
  tags = {
    Client = var.client
  }
}

resource "aws_autoscaling_group" "frontend-asg" { 
  name                = "frontend-asg"
  desired_capacity    = 2
  max_size            = 5
  min_size            = 1 
  vpc_zone_identifier = [aws_subnet.frontend-az1.id, aws_subnet.frontend-az2.id] 
  target_group_arns   = [aws_lb_target_group.frontend-tg.arn]
  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.frontend-asg.id
  alb_target_group_arn   = aws_lb_target_group.frontend-tg.arn
}

resource "aws_lb_listener" "frontend-lb-listener" {
  load_balancer_arn = aws_lb.frontend-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend-tg.arn
  }
}


# Backend
resource "aws_lb" "backend-lb" {
  security_groups    = [data.aws_security_group.internal-lb-sg.id]
  internal           = true
  subnet_mapping { 
    subnet_id        = aws_subnet.priv-app-az1.id
  }
  subnet_mapping {
    subnet_id        = aws_subnet.priv-app-az2.id
  }                                                     
}

resource "aws_lb_target_group" "backend-tg" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.backend_vpc_id
}                                

resource "aws_launch_template" "backend" {
  image_id               = var.images[var.aws_region]            
  instance_type          = var.server_type
  key_name               = var.key_name
  vpc_security_group_ids = [data.aws_security_group.backend-servers-sg.id]
  user_data              = filebase64("/mnt/c/Link/exec/cs/user_data/backend.sh")
  
  tags = {
    Client = var.client
  }
}

resource "aws_autoscaling_group" "backend-asg" {                   
  desired_capacity    = 2
  max_size            = 5
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.priv-app-az1.id, aws_subnet.priv-app-az2.id]   
  target_group_arns   = [aws_lb_target_group.backend-tg.arn]
  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_2" {
  autoscaling_group_name = aws_autoscaling_group.backend-asg.id
  alb_target_group_arn   = aws_lb_target_group.backend-tg.arn   
}

resource "aws_lb_listener" "backend-lb-listener" {
  load_balancer_arn = aws_lb.backend-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend-tg.arn
  }
}

resource "aws_db_subnet_group" "db-subg" {       
  subnet_ids = [aws_subnet.priv-db-az1.id, aws_subnet.priv-db-az2.id]
  
  tags = {
    Client = var.client
  }
}

resource "aws_kms_key" "key" {
  description             = "RDS KMS key"
  deletion_window_in_days = 10

  tags = {
    Client = var.client
  }
}

resource "aws_secretsmanager_secret" "rds" {
  kms_key_id              = aws_kms_key.default.key_id
  name                    = "rds_admin"
  description             = "RDS Admin password"
  recovery_window_in_days = 14

  tags = {
    Client = var.client
  }
}

resource "aws_secretsmanager_secret_version" "secret" {
  secret_id     = aws_secretsmanager_secret.rds.id
  secret_string = var.db_pass
}

resource "aws_db_instance" "main-db" {
  allocated_storage       = 20
  engine                  = var.db_engine
  instance_class          = "db.${var.server_type}"
  username                = "${var.db_username}"   
  password                = "${var.db_pass}"         
  db_subnet_group_name    = aws_db_subnet_group.db-subg.id 
  vpc_security_group_ids  = [var.rds-sg-id[var.db_engine]] 
  skip_final_snapshot     = true
  publicly_accessible     = true
  backup_retention_period = 10
  multi_az                = true
}