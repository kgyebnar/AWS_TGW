# Internet VPC
resource "aws_vpc" "main" {
    cidr_block = "${var.vpc_cidr}"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags {
        Name = "main"
    }
}


# Subnets
#resource "aws_subnet" "main-public-1" {
#    vpc_id = "${aws_vpc.main.id}"
#    cidr_block = "${var.pub1_cidr}"
#    map_public_ip_on_launch = "true"
#    availability_zone = "eu-central-1a"
#
#    tags {
#        Name = "main-public-1"
#    }
#}
#resource "aws_subnet" "main-public-2" {
#    vpc_id = "${aws_vpc.main.id}"
#    cidr_block = "${var.pub2_cidr}"
#    map_public_ip_on_launch = "true"
#    availability_zone = "eu-central-1b"
#
#    tags {
#        Name = "main-public-2"
#    }
#}

resource "aws_subnet" "main-private-1" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.priv1_cidr}"
    map_public_ip_on_launch = "false"
    availability_zone = "eu-central-1a"

    tags {
        Name = "main-private-1"
    }
}
resource "aws_subnet" "main-private-2" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.priv2_cidr}"
    map_public_ip_on_launch = "false"
    availability_zone = "eu-central-1b"

    tags {
        Name = "main-private-2"
    }
}

# Internet GW
#resource "aws_internet_gateway" "main-gw" {
#    vpc_id = "${aws_vpc.main.id}"

#    tags {
#        Name = "main"
#    }
#}

# Public route tables
#resource "aws_route_table" "main-public" {
#    vpc_id = "${aws_vpc.main.id}"
#    route {
#        cidr_block = "0.0.0.0/0"
#        gateway_id = "${aws_internet_gateway.main-gw.id}"
#    }

#    tags {
#        Name = "main-public-1"
#    }
#}

resource "aws_vpn_gateway" "vpn" {
amazon_side_asn = "4294967292"
  tags = {
    Name = "example-vpn-gateway"
  }
}

resource "aws_vpn_gateway_attachment" "vpn_attachment" {
  vpc_id         = "${aws_vpc.main.id}"
  vpn_gateway_id = "${aws_vpn_gateway.vpn.id}"
}


# route tables
resource "aws_route_table" "main-private" {
    vpc_id = "${aws_vpc.main.id}"
    route {
#        cidr_block = "172.31.0.0/22"
        cidr_block = "${var.vpn_cidr}"
        gateway_id = "${aws_vpn_gateway.vpn.id}"
    }
    tags {
        Name = "main-private-1"
    }
}

# route associations public
#resource "aws_route_table_association" "main-public-1-a" {
#    subnet_id = "${aws_subnet.main-public-1.id}"
#    route_table_id = "${aws_route_table.main-public.id}"
#}
#resource "aws_route_table_association" "main-public-2-a" {
#    subnet_id = "${aws_subnet.main-public-2.id}"
#    route_table_id = "${aws_route_table.main-public.id}"
#}

# route associations private
resource "aws_route_table_association" "main-private-1-a" {
    subnet_id = "${aws_subnet.main-private-1.id}"
    route_table_id = "${aws_route_table.main-private.id}"
}
resource "aws_route_table_association" "main-private-2-a" {
    subnet_id = "${aws_subnet.main-private-2.id}"
    route_table_id = "${aws_route_table.main-private.id}"
}
