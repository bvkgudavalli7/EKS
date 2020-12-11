locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.cluster.endpoint}
    certificate-authority-data: ${aws_eks_cluster.cluster.certificate_authority.0.data}
  name: ${aws_eks_cluster.cluster.name}
contexts:
- context:
    cluster: ${aws_eks_cluster.cluster.name}
    user: aws-auth
  name: default
current-context: default
kind: Config
preferences: {}
users:
- name: aws-auth
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
      - token
      - -i
      - ${aws_eks_cluster.cluster.id}
      - -r
      - ${data.aws_caller_identity.current.arn}
KUBECONFIG
}
