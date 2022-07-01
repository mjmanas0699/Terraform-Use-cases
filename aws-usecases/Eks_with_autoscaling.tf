resource "aws_eks_cluster" "cluster" {
  name     = "Autoscaler"
  role_arn = "arn:aws:iam::376604405359:role/eksClusterRole"

  vpc_config {
    subnet_ids = ["subnet-02b3dd105b1fb0e33","subnet-0fff2c4a5a7501ba8","subnet-0b31198f213e44561"]
  }

#   # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
#   # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
#   depends_on = [
#     aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
#     aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
#   ]
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
