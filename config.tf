resource "null_resource" "aws-auth" {
  triggers = {
    eks-node = length(aws_iam_role.node-group)
  }

  provisioner "local-exec" {
    command = "echo '${local.config_map_aws_auth}' >> ./aws-auth.yml"
  }
}

resource "null_resource" "kubeconfig" {
  triggers = {
    cluster-host = "${aws_eks_cluster.cluster.arn}"
  }

  provisioner "local-exec" {
    command = "echo '${local.kubeconfig}' >> ./kubeconfig"
  }
}
