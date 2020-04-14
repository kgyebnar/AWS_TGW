resource "aws_ec2_transit_gateway" "my-test-tgw" {
  description                     = "my-test-transit-gateway"
#  amazon_side_asn                 = "4294967294"
  amazon_side_asn                 = "64512"
  auto_accept_shared_attachments  = "disable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"
  tags {
    Name = "my-test-transit-gateway"
  }
}

# Route tables
resource "aws_ec2_transit_gateway_route_table" "private_table1" {
  transit_gateway_id = "${aws_ec2_transit_gateway.my-test-tgw.id}"
tags = {
    Name = "private-1"
  }
}

# Route table associations - VPC1
resource "aws_ec2_transit_gateway_route_table_association" "rt_assoc_vpc1" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.vpc-one_tgw_attachment.id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.private_table1.id}"
}

# Route table associations - VPC_shared
resource "aws_ec2_transit_gateway_route_table_association" "rt_assoc_vpc_shared" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.vpc-shared_tgw_attachment.id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.private_table1.id}"
}

# Route table associations - VPN1
 resource "aws_ec2_transit_gateway_route_table_association" "rt_assoc_vpn1" {
  transit_gateway_attachment_id  = "${aws_vpn_connection.ipsec1.transit_gateway_attachment_id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.private_table1.id}"
}

# Route table associations - VPN2
 resource "aws_ec2_transit_gateway_route_table_association" "rt_assoc_vpn2" {
  transit_gateway_attachment_id  = "${aws_vpn_connection.ipsec2.transit_gateway_attachment_id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.private_table1.id}"
}

# Route table propagation - VPC1
resource "aws_ec2_transit_gateway_route_table_propagation" "rt_propag_vpc1" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.vpc-one_tgw_attachment.id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.private_table1.id}"
}
# Route table propagation - VPN1
resource "aws_ec2_transit_gateway_route_table_propagation" "rt_propag_vpn1" {
  transit_gateway_attachment_id  = "${aws_vpn_connection.ipsec1.transit_gateway_attachment_id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.private_table1.id}"
}
# Route table propagation - VPN2
resource "aws_ec2_transit_gateway_route_table_propagation" "rt_propag_vpn2" {
  transit_gateway_attachment_id  = "${aws_vpn_connection.ipsec2.transit_gateway_attachment_id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.private_table1.id}"
}

#Static routes
resource "aws_ec2_transit_gateway_route" "route1" {
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_attachment_id  = "${aws_vpn_connection.ipsec1.transit_gateway_attachment_id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.private_table1.id}"
}
# VPC attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc-one_tgw_attachment" {
  subnet_ids         = ["${aws_subnet.main-private-1.id}","${aws_subnet.main-private-2.id}"]
  transit_gateway_id = "${aws_ec2_transit_gateway.my-test-tgw.id}"
  vpc_id             = "${aws_vpc.main.id}"
  transit_gateway_default_route_table_association ="false"
  transit_gateway_default_route_table_propagation ="false"
    tags = {
    Name = "main"
    }
}

# VPC attachment - shared
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc-shared_tgw_attachment" {
  subnet_ids         = ["${aws_subnet.shared-private-1.id}","${aws_subnet.shared-private-2.id}"]
  transit_gateway_id = "${aws_ec2_transit_gateway.my-test-tgw.id}"
  vpc_id             = "${aws_vpc.shared.id}"
  transit_gateway_default_route_table_association ="false"
  transit_gateway_default_route_table_propagation ="false"
    tags = {
    Name = "shared"
    }
}

resource "aws_customer_gateway" "cust_gw1" {
  bgp_asn    = "65071"
  ip_address = "195.228.45.146"
  type       = "ipsec.1"
    tags = {
    Name = "customer_gw"
    }
}

resource "aws_customer_gateway" "cust_gw2" {
  bgp_asn    = "65071"
  ip_address = "195.228.45.146"
  type       = "ipsec.1"
    tags = {
    Name = "customer_gw"
    }
}

resource "aws_vpn_connection" "ipsec1" {
  transit_gateway_id = "${aws_ec2_transit_gateway.my-test-tgw.id}"
  customer_gateway_id = "${aws_customer_gateway.cust_gw1.id}"
  static_routes_only  = "false"
  tunnel1_inside_cidr = "${var.tun1_cidr1}"
  tunnel2_inside_cidr = "${var.tun1_cidr2}"
  type                = "ipsec.1"
    tags = {
    Name = "vpn_connection1"
    }
}


resource "aws_vpn_connection" "ipsec2" {
  transit_gateway_id = "${aws_ec2_transit_gateway.my-test-tgw.id}"
  customer_gateway_id = "${aws_customer_gateway.cust_gw2.id}"
  static_routes_only  = "false"
  tunnel1_inside_cidr = "${var.tun2_cidr1}"
  tunnel2_inside_cidr = "${var.tun2_cidr2}"
    type                = "ipsec.1"
    tags = {
    Name = "vpn_connection2"
    }
}
