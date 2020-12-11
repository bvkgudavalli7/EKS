# eks module

Sets up an AWS EKS cluster in it's own VPC.

## Inputs

| Variable | Required| Default | Description |
|:--------:|:-------:|:-------:|:------------:|
|`cluster-name`| Y | | Name of the cluster|
|`region`| Y | | AWS region to use|
|`node-instance-type`| N | `m4.large` | Instance type for EKS nodes|
|`node-group-min`| N | `0` | Minimum size of EKS node auto-scaling group|
|`node-group-max`| N | `1` | Maximum size of EKS node auto-scaling group|
|`node-group-count`| N | `1` | Number of EKS nodes to start with|
|`keypair-name`| N | `''` | Key-pair name to use for launching instances|
|`subnet-count`| N | `1` | Number of public/private subnet pairs to make|
