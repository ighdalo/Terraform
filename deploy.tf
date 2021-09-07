provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "us-east-1"
}

module "ec2_test" {
  source        = "/home/labadmin/TerraformProject/modules/ec2_setup"
  ec2_count     = 2
  ami           = "ami-09e67e426f25ce0d7"
  instance_type = "t2.micro"
  server_name   = "test_server"

}
