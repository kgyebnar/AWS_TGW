variable "AWS_REGION" {
  default = "eu-central-1"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "AMIS" {
  type = "map"
  default = {
    us-east-1    = "ami-13be557e"
    us-west-2    = "ami-06b94666"
    eu-west-1    = "ami-844e0bf7"
    eu-central-1 = "ami-027583e616ca104df"
  }
}

variable "vpn_cidr" {
  default = "0.0.0.0/0"
}

variable "pub1_cidr" {
  default = "10.0.111.0/24"
}

variable "pub2_cidr" {
  default = "10.0.2.0/24"
}

variable "priv1_cidr" {
  default = "10.0.1.0/24"
}

variable "priv2_cidr" {
  default = "10.0.2.0/24"
}

variable "shared_priv1_cidr" {
  default = "10.40.22.0/25"
}

variable "shared_priv2_cidr" {
  default = "10.40.22.128/25"
}

variable "shared_vpc_cidr" {
  default = "10.40.22.0/24"
}

variable "vpc_cidr" {
  default = "10.1.0.0/22"
}

variable "tun1_cidr1" {
  default = "169.254.255.0/30"
}

variable "tun1_cidr2" {
  default = "169.254.255.4/30"
}

variable "tun2_cidr1" {
  default = "169.254.255.8/30"
}

variable "tun2_cidr2" {
  default = "169.254.255.12/30"
}

variable "vpn_gw_id" {
  default = "vgw-0d4b2f846b7512011"
}

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}
