resource "aws_subnet" "dev_private" {
  for_each                = var.private_subnet_names
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet_cidr_blocks_private[each.key]
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name = each.value
    Tier = "private"
  })
}
