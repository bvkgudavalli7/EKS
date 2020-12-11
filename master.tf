resource "aws_eks_cluster" "cluster" {
  name     = var.cluster.name
  role_arn = aws_iam_role.cluster-role.arn
  version  = var.cluster.version

  vpc_config {
    security_group_ids  = [aws_security_group.cluster-sg.id]
    subnet_ids          = var.vpc.subnets-all
    public_access_cidrs = var.public-access-cidrs
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy,
  ]
}
