# EKS Node Groups
resource "aws_eks_node_group" "node-groups" {
  count           = length(var.node-groups)
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = var.node-groups[count.index].name
  node_role_arn   = aws_iam_role.node-group[count.index].arn
  subnet_ids      = var.vpc.subnets-private
  version         = var.cluster.version
  labels          = var.node-groups[count.index].labels
  remote_access {
    ec2_ssh_key               = var.node-groups[count.index].ec2-ssh-key
    source_security_group_ids = var.node-groups[count.index].ec2-ssh-security-groups
  }

  scaling_config {
    desired_size = var.node-groups[count.index].count-desired
    min_size     = var.node-groups[count.index].count-min
    max_size     = var.node-groups[count.index].count-max
  }

  depends_on = [
    aws_iam_policy_attachment.cluster-node-AmazonEKSWorkerNodePolicy,
    aws_iam_policy_attachment.cluster-node-AmazonEKS_CNI_Policy,
    aws_iam_policy_attachment.cluster-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}
