
resource "aws_instance" "test_server" {
      count = var.ec2_count 
      ami = var.ami 
      instance_type = var.instance_type
     
      tags = {

        Name = var.server_name

}
    }


