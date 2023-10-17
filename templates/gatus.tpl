[{
  "cpu": ${cpu},
  "image": "${image}",
  "memory": ${memory},
  "name": "${name}",
  "networkMode": "awsvpc",
  "portMappings": [{
      "containerPort": 8080,
      "hostPort": 8080,
      "protocol": "tcp"
  }],
  "environment": [
    %{ if database != null }
    {
      "name": "DB_HOST",
      "value": "${database.host}"
    },
    {
      "name": "DB_PORT",
      "value": "${tostring(database.port)}"
    },
    {
      "name": "DB_NAME",
      "value": "${database.name}"
    },
    %{ endif }
    {
      "name": "GATUS_CONFIG_PATH",
      "value": "${config_path}"
    }
  ],
  %{ if database != null }
  "secrets": [
    {
      "name": "DB_USER",
      "valueFrom": "${database.user}"
    },
    {
      "name": "DB_PASSWORD",
      "valueFrom": "${database.password}"
    }
  ],
  %{ endif }
  %{ if log_group != "" }
  "logConfiguration": {
    "logDriver": "awslogs",
    "options": {
      "awslogs-group": "${log_group}",
      "awslogs-region": "${region}",
      "awslogs-stream-prefix": "${name}"
    }
  },
  %{ endif }
  "placementStrategy": [
    {
      "field": "attribute:ecs.availability-zone",
      "type": "spread"
    }
  ]
}]
