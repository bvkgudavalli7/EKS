# Node Group Permissions

# Node Group EC2 Assume Role Trust Policy
data "aws_iam_policy_document" "cluster-node-trust" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

# Node Group policy attachments
resource "aws_iam_policy_attachment" "cluster-node-AmazonEKSWorkerNodePolicy" {
  name       = "${var.cluster.name}-node-group-eks_worker_policy"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  roles      = aws_iam_role.node-group[*].name
}

resource "aws_iam_policy_attachment" "cluster-node-AmazonEKS_CNI_Policy" {
  name       = "${var.cluster.name}-node-group-eks_cni_policy"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  roles      = aws_iam_role.node-group[*].name
}

resource "aws_iam_policy_attachment" "cluster-node-AmazonEC2ContainerRegistryReadOnly" {
  name       = "${var.cluster.name}-node-group-ec2_container_registry_policy_readonly"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  roles      = aws_iam_role.node-group[*].name
}

# Node IAM Role(s)
resource "aws_iam_role" "node-group" {
  count              = length(var.node-groups)
  name               = "${var.cluster.name}-${var.node-groups[count.index].name}-node"
  assume_role_policy = data.aws_iam_policy_document.cluster-node-trust.json
}

# Allow node group to assume roles in the current account
data "aws_iam_policy_document" "node-group-assume-role" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*"]
  }
}

resource "aws_iam_policy" "node-group-assume-role" {
  name   = "${var.cluster.name}-node-group-assume-role"
  policy = data.aws_iam_policy_document.node-group-assume-role.json
}

resource "aws_iam_role_policy_attachment" "node-group-assume-role" {
  count      = length(aws_iam_role.node-group)
  role       = aws_iam_role.node-group[count.index].name
  policy_arn = aws_iam_policy.node-group-assume-role.arn
}

