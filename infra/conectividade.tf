###################################################################################################################
# Rede 
###################################################################################################################

locals {
 
  availability_zones_public  = { for az, _ in var.public_subnet_names : az => az }
  availability_zones_private = { for az, _ in var.private_subnet_names : az => az }
}

module "vpc_app" {
  source         = "../modulos/Conectividade/prod/vpc"
  vpc_cidr_block = var.vpc_cidr_block
  tags           = merge(local.common_tags, { Name = "${var.project_name}-vpc" })
}

module "internet_gateway" {
  source = "../modulos/Conectividade/prod/internet-gateway"
  vpc_id = module.vpc_app.vpc_id
  tags   = merge(local.common_tags, { Name = "${var.project_name}-igw" })
}

module "subnet_public" {
  source                    = "../modulos/Conectividade/prod/subnets/public-subnet"
  vpc_id                    = module.vpc_app.vpc_id
  subnet_cidr_blocks_public = var.subnet_cidr_blocks_public
  public_subnet_names       = var.public_subnet_names
  availability_zones        = local.availability_zones_public
  tags                      = local.common_tags
}

module "subnet_private" {
  source                     = "../modulos/Conectividade/prod/subnets/private-subnet"
  vpc_id                     = module.vpc_app.vpc_id
  subnet_cidr_blocks_private = var.subnet_cidr_blocks_private
  private_subnet_names       = var.private_subnet_names
  availability_zones         = local.availability_zones_private
  tags                       = local.common_tags
}

resource "aws_route_table" "public" {
  vpc_id = module.vpc_app.vpc_id
  tags   = merge(local.common_tags, { Name = "${var.project_name}-public-rt" })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.internet_gateway.internet_gateway_id
}

resource "aws_route_table_association" "public" {
  for_each = var.public_subnet_names

  subnet_id      = module.subnet_public.public_subnet_ids_by_name[each.value]
  route_table_id = aws_route_table.public.id
}

# Route table privada 
resource "aws_route_table" "private" {
  vpc_id = module.vpc_app.vpc_id
  tags   = merge(local.common_tags, { Name = "${var.project_name}-private-rt" })
}

resource "aws_route_table_association" "private" {
  for_each = var.private_subnet_names

  subnet_id      = module.subnet_private.private_subnet_ids_by_name[each.value]
  route_table_id = aws_route_table.private.id
}
