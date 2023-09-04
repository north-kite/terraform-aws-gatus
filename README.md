# repo-template-terraform
Repo template for Terraform modules

Template aims to follow general style and structure guidelines from Google:

https://cloud.google.com/docs/terraform/best-practices-for-terraform


Template includes [Kitchen Terraform](https://newcontext-oss.github.io/kitchen-terraform/)
test framework.

Template includes the following GitHub Actions:
- Terraform
  - Check Terraform format
  - Run Checkmarx KICS scan
- AWS
  - Authenticate to AWS
  - Test credentials

TODO:
- add GitHub Actions for:
  - Kitchen Terraform (option to enable)
