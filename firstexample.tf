provider "aws" {
	access_key = "${var.access_key}"
	secret_key = "${var.secret_key}"
	region = "${var.region}"
}

resource "aws_instance" "sharmiterraform1" {
	ami = "ami-06358f49b5839867c"
	instance_type= "t2.micro"
	key_name="${aws_key_pair.sharmitfkey.id}"
	tags = {
	Name = "sharmiInstance"
	}
	vpc_security_group_ids = ["${aws_security_group.sharmitfsecgroup.id}"]

provisioner "local-exec" {
	when = "destroy" 
	command = "echo ${aws_instance.sharmiterraform1.public_ip}>sample.txt"
}

provisioner "chef" {
	connection {
	host = "${self.public_ip}"
	type = "ssh"
	user = "ubuntu"
	private_key = "${file("C:\\project\\mykey.pem")}"
	}
	client_options = ["chef_license 'accept'"]
	run_list = ["testchef::default"]
	recreate_client = true
	node_name = "tfsharmi.acc.com"
	server_url = "https://manage.chef.io/organizations/orgproject"
	user_name= "sharmiladevie"
	user_key = "${file("C:\\chef-starter\\chef-repo\\.chef\\sharmiladevie.pem")}"
	ssl_verify_mode = ":verify_none"
}
}

resource "aws_key_pair" "sharmitfkey" {
	key_name = "sharmikeypair"
	public_key = "${file("C:\\project\\mykey.pub")}"
}

resource "aws_security_group" "sharmitfsecgroup" {
	name = "sharmisecgroup"
	description = "to allow traffic"

	ingress {
		from_port = "0"
		to_port = "0"
		protocol= "-1"
		cidr_blocks=["0.0.0.0/0"]
	}

	egress{
		from_port = "0"
		to_port = "0"
		protocol= "-1"
		cidr_blocks=["0.0.0.0/0"]
	}
}


resource "aws_s3_bucket" "sharmibucket" {
bucket = "sharmibucket"
acl = "private"
force_destroy = "true"
}


terraform {
backend "s3" {
bucket = "sharmibucket"
key = "terraform.tfstate"
region = "eu-west-1"
}
}