resource "aws_instance" "example" {
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = "${aws_subnet.main-public-1.id}"

  # the security group
  vpc_security_group_ids = ["${aws_security_group.allow-filters.id}"]

  # the public SSH key
  key_name = "${aws_key_pair.mykeypair.key_name}"

  provisioner "file" {
    source = "script.sh"
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh"
    ]
  }
  connection {
    user = "${var.INSTANCE_USERNAME}"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.example.private_ip} > private_ips.txt"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > public_ips.txt"
  }

}

resource "aws_network_interface" "bar" {
  subnet_id = "${aws_subnet.main-private-2.id}"
   tags {
    Name = "secondary_network_interface"
#  security_groups = ["${aws_security_group.allow-filters.id}"]
  }
}

resource "aws_network_interface" "foo" {
  subnet_id = "${aws_subnet.main-public-2.id}"
   tags {
    Name = "secondary_network_interface"
#  security_groups = ["${aws_security_group.allow-filters2.id}"]
  }
}

resource "aws_instance" "example2" {
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
  # the VPC subnet
#  subnet_id = "${aws_subnet.main-public-2.id}"
 network_interface {
     network_interface_id = "${aws_network_interface.bar.id}"
     device_index = 1
  }
 network_interface {
     network_interface_id = "${aws_network_interface.foo.id}"
     device_index = 0
  }

  # the public SSH key
  key_name = "${aws_key_pair.mykeypair.key_name}"
}

output "ip"
{
value = "${aws_instance.example.public_ip}"
}

