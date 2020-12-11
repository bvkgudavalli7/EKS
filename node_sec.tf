resource "aws_security_group" "cluster-node-sg" {
  name        = "${var.cluster.name}-node-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = var.vpc.id

  egress {
    description = "Outbound to anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = map(
    "Name", "${var.cluster.name}-node-sg",
    "kubernetes.io/cluster/${var.cluster.name}", "owned"
  )
}

resource "aws_security_group" "node-group-sg" {
  count       = length(var.node-groups)
  name        = "${var.cluster.name}-${var.node-groups[count.index].name}-sg"
  description = "Security group for EKS node group ${var.cluster.name}-${var.node-groups[count.index].name}"

  tags = map(
    "Name", "${var.cluster.name}-${var.node-groups[count.index].name}-sg",
    "kubernetes.io/cluster/${var.cluster.name}", "owned"
  )
}



resource "aws_security_group_rule" "cluster-node-ingress-self" {
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.cluster-node-sg.id
  source_security_group_id = aws_security_group.cluster-node-sg.id
  to_port                  = 65535
  type                     = "ingress"
}


resource "aws_security_group_rule" "cluster-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster-node-sg.id
  source_security_group_id = aws_security_group.cluster-sg.id
  to_port                  = 65535
  type                     = "ingress"
}


resource "aws_security_group_rule" "cluster-node-ingress-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster-sg.id
  source_security_group_id = aws_security_group.cluster-node-sg.id
  to_port                  = 443
  type                     = "ingress"
}
