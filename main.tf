resource "aws_ecs_cluster" "my_flask_app_cluster" {
  name = "my-flask-app-cluster"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "my_flask_app_task" {
  family                   = "my-flask-app-task"
  container_definitions    = jsonencode([
    {
      name      = "my-flask-app"
      image     = "303981612052.dkr.ecr.us-east-1.amazonaws.com/my-flask-app:latest"
      memory    = 512
      cpu       = 256
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
    }
  ])
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
}

# ECS Service
resource "aws_ecs_service" "my_flask_app_service" {
  name            = "my-flask-app-service"
  cluster         = aws_ecs_cluster.my_flask_app_cluster.id
  task_definition = aws_ecs_task_definition.my_flask_app_task.arn
  desired_count   = 2

  # Load balancer configuration if needed
  # load_balancer {
  #   target_group_arn = aws_lb_target_group.my_target_group.arn
  #   container_name   = "my-flask-app"
  #   container_port   = 5000
  # }

  launch_type = "EC2"
}
