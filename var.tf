#variable for ami
variable "ami" {
type = string
description = "ec2 ami ID "
}

#variable for instance type
variable "instance_type" {
type = string
description = "instance type yo be created"

}

#variable for ec2 count
variable "ec2_count" {
type = string
description = "number of ec2 instance to create"

}

#variable for ec2 server name
variable "server_name" {
type = string
description = "ec2 server name"
 }

