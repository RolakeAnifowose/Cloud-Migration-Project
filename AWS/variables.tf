variable "region" {
    default = "us-east-1"
}

variable "instance_names" {
    default = ["webapp1", "webapp2"]
}

variable "ami" {
    default = "ami-053b0d53c279acc90" #Ubuntu AMI
}

variable "instance_type" {
    default = "t2.micro"
}
