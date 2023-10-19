# Required Variables

variable "env" {
  description = "Environment name, used in resource names (e.g. dev, stage, prod)"
  type        = string
}

variable "ecs_cluster" {
  description = "ECS Cluster to deploy to"
  type = object({
    arn  = string
    name = string
  })
}

variable "vpc_id" {
  description = "VPC that resources should be deployed to"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs to deploy the service to"
  type        = set(string)
}

variable "alb_listener_config" {
  description = "Map of config for application load balancer listeners"
  type = object({
    port                = number
    health_check_port   = number
    protocol            = string # HTTP or HTTPS
    allowed_cidr_blocks = list(string)
    certificate_arn     = string # required if protocol is HTTPS
    path                = string
  })
}

# Optional Variables
variable "service_name" {
  description = "(Optional) Name of the service/product/application this Gatus belongs to"
  type        = string
  default     = "my-service"
}

variable "enable_execute_command" {
  description = "(Optional) Enable Amazon ECS Exec for tasks"
  type        = bool
  default     = true
}

variable "platform_version" {
  description = "(Optional) ECS Fargate platform version"
  type        = string
  default     = "1.4.0"
}

variable "use_fargate" {
  description = "(Optional) Launch on Fargate. If set to `false` then EC2 will be used"
  type        = bool
  default     = true
}

variable "size" {
  description = "(Optional) Number of ECS tasks to run"
  type = object({
    min     = number
    max     = number
    desired = number
  })
  default = {
    min     = 0
    max     = 2
    desired = 1
  }
}

variable "security_groups" {
  description = "(Optional) List of additional security group IDs to assign to the service"
  type        = list(string)
  default     = []
}

variable "cpu" {
  description = "(Optional) CPU to allocate to each Gatus"
  type        = number
  default     = 256

  validation {
    condition     = contains([256, 512, 1024, 2048, 4096], var.cpu)
    error_message = "Must be one of the following values: 256, 512, 1024, 2048, 4096."
  }
}

variable "memory" {
  description = "(Optional) Memory to allocate to each Gatus"
  type        = number
  default     = 512

  validation {
    condition     = contains([512, 1024, 2048, 3072, 4096, 5120, 6144, 7168, 8192, 9216, 10240, 11264, 12288, 13312, 14336, 15360, 16384, 17408, 18432, 19456, 20480, 21504, 22528, 23552, 24576, 25600, 26624, 27648, 28672, 29696, 30720], var.memory)
    error_message = "Must be either 512 or a multiple of 1024, up to 30720."
  }
}

variable "image" {
  description = "(Optional) Container image URI to use for Gatus"
  type        = string
  default     = "twinproduction/gatus:v4.2.0"
}

variable "config_path" {
  description = "(Optional) File location of config files within container"
  type        = string
  default     = "/config/"
}

variable "log_group" {
  description = "(Optional) The CloudWatch Log Group for service to send logs to"
  type = object({
    arn    = string
    region = string
  })
  default = null
}

variable "execution_role_arn" {
  description = "(Optional) ARN of the IAM role to launch the ECS task"
  type        = string
  #  default     = null # TODO create if null OR make required
}

variable "alb" {
  description = "(Optional) ARN and security group ID of existing application load balancer to attach Gatus too. If unspecified then an ALB will be created."
  type = object({
    arn               = string
    security_group_id = string
  })
  default = null
}

variable "public" {
  description = "(Optional) If `true` then containers will be assigned public IPs and ALB will be made public."
  type        = bool
  default     = false
}

variable "database" {
  description = "(Optional) Database name and connection details. If set, these will be added to container environment variables for use in Gatus config. ARNs of Secret Manager secrets or Parameter Store parameters should be provided for `user` and `password`."
  type = object({
    host         = string
    port         = number
    name         = string
    user_arn     = string
    password_arn = string
  })
  default = null
}
