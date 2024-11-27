module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.7.0"
 
  name = local.instance_name
  subnet_id              = aws_subnet.public_zone1.id
  ami                    = "ami-0614680123427b75e"
  instance_type          = "t3a.medium"
  associate_public_ip_address = true
  key_name               = "subspace"
  vpc_security_group_ids = [module.security_group.security_group_id]
  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.2.0"
  name        = "main-sg"
  description = "Security group which is used as an argument in complete-sg"
  vpc_id      = aws_vpc.main.id
  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "All traffic from VPC CIDR"
      cidr_blocks = "10.0.0.0/16"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH access from anywhere"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
 
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow all outbound traffic"
    }
  ]
}