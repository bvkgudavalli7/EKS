output "node-sg-id" {
  value = aws_security_group.cluster-node-sg.id
}

output "node-iam-role-arn" {
  value = aws_iam_role.node-group[0].arn
}

output "node-iam-role-name" {
  value = aws_iam_role.node-group[0].name
}

output "name" {
  value = aws_eks_cluster.cluster.id
}
