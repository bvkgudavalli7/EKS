locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
%{ for role in aws_iam_role.node-group ~}
    - rolearn: ${role.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
%{ endfor ~}
%{ for role in var.cluster.admin-iam-roles ~}
    - rolearn: ${role}
      username: admin
      groups:
        - system:masters
%{ endfor ~}
CONFIGMAPAWSAUTH
}
