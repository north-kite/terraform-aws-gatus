provider "aws" {
  default_tags {
    tags = {
      Name = "${var.env}-gatus-default"
    }
  }
}
