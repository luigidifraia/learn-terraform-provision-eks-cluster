data "aws_availability_zones" "available" {}

# Sometimes it is handy to keep the same IPs even after the VPC is destroyed and re-created.
# To that end, it is possible to assign existing IPs to the NAT Gateways.
# This prevents the "targeted" destruction of the VPC from releasing those IPs, while making it possible that a re-created VPC uses the same IPs.
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.32.0#external-nat-gateway-ips
resource "aws_eip" "nat" {
  count = 1

  vpc = true
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"

  name                 = "education-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  reuse_nat_ips        = true               # <= Skip creation of EIPs for the NAT Gateways
  external_nat_ip_ids  = aws_eip.nat.*.id   # <= IPs specified here as input to the module
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}
