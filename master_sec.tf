resource "aws_security_group" "cluster-sg" {
  name        = "${var.cluster.name}-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.cluster.name
  }
}
