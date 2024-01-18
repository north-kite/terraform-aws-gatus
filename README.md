# Gatus AWS Terraform Module

Terraform module to deploy [Gatus](https://github.com/TwiN/gatus) on AWS

<!-- BEGIN_TF_DOCS -->
## Terraform Module Documentation

This documentation is generated using https://terraform-docs.io

To update these docs run `terraform-docs .` from this directory.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_alb_listener_rule.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener_rule) | resource |
| [aws_ecs_service.gatus](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.gatus](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.gatus](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_lb.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.gatus](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.gatus_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.gatus_alb_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.gatus_alb_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.gatus_ingress_from_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_iam_policy_document.ecs_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_subnet.gatus](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb"></a> [alb](#input\_alb) | (Optional) ARN and security group ID of existing application load balancer to attach Gatus too. If unspecified then an ALB will be created. | <pre>object({<br>    arn               = string<br>    security_group_id = string<br>  })</pre> | `null` | no |
| <a name="input_alb_listener_config"></a> [alb\_listener\_config](#input\_alb\_listener\_config) | Map of config for application load balancer listeners | <pre>object({<br>    port                = number<br>    health_check_port   = number<br>    protocol            = string # HTTP or HTTPS<br>    allowed_cidr_blocks = list(string)<br>    certificate_arn     = string # required if protocol is HTTPS<br>    path                = string<br>  })</pre> | n/a | yes |
| <a name="input_config_path"></a> [config\_path](#input\_config\_path) | (Optional) File location of config files within container | `string` | `"/config/"` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | (Optional) CPU to allocate to each Gatus | `number` | `256` | no |
| <a name="input_database"></a> [database](#input\_database) | (Optional) Database name and connection details. If set, these will be added to container environment variables for use in Gatus config. ARNs of Secret Manager secrets or Parameter Store parameters should be provided for `user` and `password`. | <pre>object({<br>    host         = string<br>    port         = number<br>    name         = string<br>    user_arn     = string<br>    password_arn = string<br>  })</pre> | `null` | no |
| <a name="input_ecs_cluster"></a> [ecs\_cluster](#input\_ecs\_cluster) | ECS Cluster to deploy to | <pre>object({<br>    arn  = string<br>    name = string<br>  })</pre> | n/a | yes |
| <a name="input_enable_execute_command"></a> [enable\_execute\_command](#input\_enable\_execute\_command) | (Optional) Enable Amazon ECS Exec for tasks | `bool` | `true` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment name, used in resource names (e.g. dev, stage, prod) | `string` | n/a | yes |
| <a name="input_env_vars"></a> [env\_vars](#input\_env\_vars) | (Optional) Map of environment variables to add to the container. This can be referenced in the Gatus config files. e.g. `{ FRONT_END = "https://example.com" }` | `map(string)` | `{}` | no |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | (Optional) ARN of the IAM role to launch the ECS task | `string` | n/a | yes |
| <a name="input_image"></a> [image](#input\_image) | (Optional) Container image URI to use for Gatus | `string` | `"twinproduction/gatus:v4.2.0"` | no |
| <a name="input_log_group"></a> [log\_group](#input\_log\_group) | (Optional) The CloudWatch Log Group for service to send logs to | <pre>object({<br>    arn    = string<br>    region = string<br>  })</pre> | `null` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | (Optional) Memory to allocate to each Gatus | `number` | `512` | no |
| <a name="input_platform_version"></a> [platform\_version](#input\_platform\_version) | (Optional) ECS Fargate platform version | `string` | `"1.4.0"` | no |
| <a name="input_public"></a> [public](#input\_public) | (Optional) If `true` then containers will be assigned public IPs and ALB will be made public. | `bool` | `false` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | (Optional) Map of secrets to add to the container. The values should be ARNs for Secrets Manager or SSM Parameter Store | `map(string)` | `{}` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | (Optional) List of additional security group IDs to assign to the service | `list(string)` | `[]` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | (Optional) Name of the service/product/application this Gatus belongs to | `string` | `"my-service"` | no |
| <a name="input_size"></a> [size](#input\_size) | (Optional) Number of ECS tasks to run | <pre>object({<br>    min     = number<br>    max     = number<br>    desired = number<br>  })</pre> | <pre>{<br>  "desired": 1,<br>  "max": 2,<br>  "min": 0<br>}</pre> | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnet IDs to deploy the service to | `set(string)` | n/a | yes |
| <a name="input_use_fargate"></a> [use\_fargate](#input\_use\_fargate) | (Optional) Launch on Fargate. If set to `false` then EC2 will be used | `bool` | `true` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC that resources should be deployed to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | Application loadbalancer DNS name. This DNS name can be used directly or in a custom DNS record. |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Security group assigned to Gatus container. Add rules here to grant Gatus access to endpoint to monitor. |
<!-- END_TF_DOCS -->
