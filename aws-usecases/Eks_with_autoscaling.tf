resource "aws_eks_cluster" "cluster" {
  name     = "Autoscaler"
  role_arn = "arn:aws:iam::376604405359:role/eksClusterRole"

  vpc_config {
    subnet_ids = ["subnet-02b3dd105b1fb0e33","subnet-0fff2c4a5a7501ba8","subnet-0b31198f213e44561"]
  }

    kubernetes_network_config {
        service_ipv4_cidr ="192.168.1.0/24"
    }
}

output "endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name      = aws_eks_cluster.cluster.name
  addon_name        = "vpc-cni"
  depends_on        =[aws_eks_cluster.cluster]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name      = aws_eks_cluster.cluster.name
  addon_name        = "kube-proxy"
  depends_on        =[aws_eks_cluster.cluster]
}
resource "aws_eks_addon" "coredns" {
  cluster_name      = aws_eks_cluster.cluster.name
  addon_name        = "coredns"
  depends_on        =[aws_eks_cluster.cluster]
}

resource "aws_eks_node_group" "cluster" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "Autoscaler-ng"
  node_role_arn   = "arn:aws:iam::376604405359:role/AmazonEKSNodeRole"
  subnet_ids      = ["subnet-02b3dd105b1fb0e33","subnet-0fff2c4a5a7501ba8","subnet-0b31198f213e44561"]
  disk_size       = 10
  instance_types  = ["t3.medium"]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  # scaling_config {
  #   taint {
  #     key    =  "key1"
  #     value  =  "value"
  #     effect = "NO_SCHEDULE"
  #   }
  # }
}