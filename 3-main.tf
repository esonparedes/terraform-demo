# Set local variables
locals {
  common_name  = "terraform-demo"
  subnet_ids   = [aws_subnet.private-1a.id, aws_subnet.private-1b.id]
  keypair_name = var.keypair_name == null ? aws_key_pair.web-new-key[0].id : data.aws_key_pair.pre-existing-key[0].id
}

# Create the EC2 instance
resource "aws_instance" "web" {
  count                       = 2
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = element(local.subnet_ids, count.index)
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true
  key_name                    = local.keypair_name

  root_block_device {
    encrypted             = true
    kms_key_id            = data.aws_kms_alias.aws-ebs.arn
    delete_on_termination = true
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "${local.common_name}-web-instance-${count.index + 1}"
  }
}

# Key pair setup, create a new one.
resource "aws_key_pair" "web-new-key" {
  count      = var.keypair_name == null ? 1 : 0
  key_name   = "${local.common_name}-web-key"
  public_key = file(var.public_key_local_path) # you can specify the location of your public key.
}

# Or, use the existing one.
data "aws_key_pair" "pre-existing-key" {
  count    = var.keypair_name == null ? 0 : 1
  key_name = var.keypair_name
}