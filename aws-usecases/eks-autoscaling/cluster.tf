#Cluster Creation

resource "aws_eks_cluster" "cluster" {
  name     = "Autoscaler"
  role_arn = "arn:aws:iam::376604405359:role/eksClusterRole"

  vpc_config {
    subnet_ids = ["subnet-02b3dd105b1fb0e33", "subnet-0fff2c4a5a7501ba8", "subnet-0b31198f213e44561"]
  }

  kubernetes_network_config {
    service_ipv4_cidr = "192.168.1.0/24"
  }
}

# NODE GROUP
resource "aws_eks_node_group" "cluster" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "Autoscaler-ng"
  node_role_arn   = "arn:aws:iam::376604405359:role/AmazonEKSNodeRole"
  subnet_ids      = ["subnet-02b3dd105b1fb0e33", "subnet-0fff2c4a5a7501ba8", "subnet-0b31198f213e44561"]
  disk_size       = 10
  instance_types  = ["t3.medium"]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  depends_on = [aws_eks_cluster.cluster]
}

# Addons
variable "addons" {
  type    = list(any)
  default = ["vpc-cni", "kube-proxy", "coredns"]
}
resource "aws_eks_addon" "addons" {
  cluster_name = aws_eks_cluster.cluster.name
  for_each     = toset(var.addons)
  addon_name   = each.value
  depends_on   = [aws_eks_cluster.cluster]
}