module "security_group" {
  source              = "./modules/security-group"
  name                = "ec2-sg"
  description         = "Security group for EC2 instance"
  vpc_id              = var.vpc_id
  allowed_ssh_cidrs   = ["0.0.0.0/0"]
  tags                = {
    Project = "TerraformInfra"
  }
}

module "ec2_instance" {
  source             = "./modules/ec2"
  ami                = "ami-084568db4383264d4" 
  instance_type      = "t2.micro"
  subnet_id          = var.subnet_id
  security_group_ids = [module.security_group.security_group_id]
  key_name           = var.key_name
  tags               = {
    Name = "TerraformEC2"
  }
}
