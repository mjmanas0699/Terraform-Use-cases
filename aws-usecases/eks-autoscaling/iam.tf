#IAM Roles,Policy & OIDC

resource "aws_iam_policy" "policy" {
  name        = "AmazonEKSClusterAutoscalerPolicy"
  description = "Autoscaling Policy"
  depends_on  = [aws_eks_node_group.cluster]
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : [
            "autoscaling:SetDesiredCapacity",
            "autoscaling:TerminateInstanceInAutoScalingGroup"
          ],
          "Resource" : "*",
          "Condition" : {
            "StringEquals" : {
              "aws:ResourceTag/k8s.io/cluster-autoscaler/${aws_eks_cluster.cluster.name}" : "owned"
            }
          }
        },
        {
          "Sid" : "VisualEditor1",
          "Effect" : "Allow",
          "Action" : [
            "autoscaling:DescribeAutoScalingInstances",
            "autoscaling:DescribeAutoScalingGroups",
            "ec2:DescribeLaunchTemplateVersions",
            "autoscaling:DescribeTags",
            "autoscaling:DescribeLaunchConfigurations"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}

variable "oidc_thumbprint_list" {
  type = string
}
resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [var.oidc_thumbprint_list] #https://github.com/hashicorp/terraform-provider-aws/issues/10104
  url             = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
  depends_on      = [aws_eks_node_group.cluster]
}

resource "aws_iam_role" "role" {
  name = "AmazonEKSClusterAutoscalerRole"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Federated" : "${aws_iam_openid_connect_provider.cluster.arn}"
          },
          "Action" : "sts:AssumeRoleWithWebIdentity",
          "Condition" : {
            "StringEquals" : {
              "${aws_iam_openid_connect_provider.cluster.url}:sub" : "system:serviceaccount:kube-system:cluster-autoscaler"
            }
          }
        }
      ]
    }
  )
  depends_on = [aws_iam_policy.policy]
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
  depends_on = [aws_iam_role.role, aws_iam_policy.policy]
}