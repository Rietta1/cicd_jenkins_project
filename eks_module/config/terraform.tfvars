
aws_eks_cluster_config = {

      "demo-cluster" = {

        eks_cluster_name         = "demo-cluster1"
        eks_subnet_ids = ["subnet-04bbcf18fece0b8ec","subnet-0603ada82a247b2e3","subnet-0b16487b78ac06659","subnet-0f6e902a5074d20e8"]
        tags = {
             "Name" =  "demo-cluster"
         }  
      }
}

eks_node_group_config = {

  "node1" = {

        eks_cluster_name         = "demo-cluster"
        node_group_name          = "mynode"
        nodes_iam_role           = "eks-node-group-general1"
        node_subnet_ids          = ["subnet-04bbcf18fece0b8ec","subnet-0603ada82a247b2e3","subnet-0b16487b78ac06659","subnet-0f6e902a5074d20e8"]

        tags = {
             "Name" =  "node1"
         } 
  }
}