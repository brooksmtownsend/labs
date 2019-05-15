+++
title = "AWS Account Setup"
date = 2019-04-23T09:43:37-04:00
weight = 5
chapter = false
pre = "<i class='fas fa-user-circle'></i> "
+++

## AWS Account Creation


1.  Go to [AWS](aws.amazon.com) and register for a new free account.

	![freeaccount](../../../images/install/awsaccount/free_account.png)
	
1.  Sign up for a new account:

	![awsaccountcreation](../../../images/install/awsaccount/aws_creation.png)

1.  Fill our your information including **Payment Information** so that Amazon can verify your identity.

1.  Verify your account:

	![verifyaccount](../../../images/install/awsaccount/verify_account.png)
	
1.  Sign in to your account:

	![awssignin](../../../images/install/awsaccount/aws_signin.png)
	

## Manage User Access 

1.  From the **AWS Management Console** -> **Find Services** search for `IAM` (Manage User Access and Encryption Key).

	![iam](../../../images/install/awsaccount/iam.png)



1. Click **Policies** from the Navigation.

1.  It is recommended that you create a new limited access policy rather than giving a user `admin` access.  For the purpose of the Critical Stack install we will create a new **policy** with only the permissions needed to build the cluster.  Click **Create policy** .

	![policies](../../../images/install/awsaccount/policies.png)
	

1.  In the new **Create policy** window you can create a new policy with the Visual editor or with JSON (JavaScript Object Notation).  Select **JSON**

	![json](../../../images/install/awsaccount/json.png)
	

1.  You can use use this [sample json policy definition](../../../res/cs_minimum_policy_install.json) or copy the text below within the JSON editor window.

    ```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "CriticalStackInstallationPolicy",
                "Effect": "Allow",
                "Action": [
                    "autoscaling:AttachInstances",
                    "autoscaling:AttachLoadBalancers",
                    "autoscaling:AttachLoadBalancerTargetGroups",
                    "autoscaling:CreateAutoScalingGroup",
                    "autoscaling:CreateLaunchConfiguration",
                    "autoscaling:CreateOrUpdateTags",
                    "autoscaling:DeleteAutoScalingGroup",
                    "autoscaling:DeleteLaunchConfiguration",
                    "autoscaling:DeleteTags",
                    "autoscaling:DescribeAutoScalingGroups",
                    "autoscaling:DescribeAutoScalingInstances",
                    "autoscaling:DescribeAutoScalingNotificationTypes",
                    "autoscaling:DescribeLaunchConfigurations",
                    "autoscaling:DescribeLoadBalancers",
                    "autoscaling:DescribeLoadBalancerTargetGroups",
                    "autoscaling:DescribePolicies",
                    "autoscaling:DescribeScalingActivities",
                    "autoscaling:DescribeTags",
                    "autoscaling:DetachInstances",
                    "autoscaling:DetachLoadBalancers",
                    "autoscaling:DetachLoadBalancerTargetGroups",
                    "autoscaling:SetDesiredCapacity",
                    "autoscaling:SetInstanceHealth",
                    "autoscaling:TerminateInstanceInAutoScalingGroup",
                    "autoscaling:UpdateAutoScalingGroup",
                    "ec2:AllocateAddress",
                    "ec2:AssociateAddress",
                    "ec2:AssociateIamInstanceProfile",
                    "ec2:AssociateRouteTable",
                    "ec2:AttachInternetGateway",
                    "ec2:AttachNetworkInterface",
                    "ec2:AttachVolume",
                    "ec2:AuthorizeSecurityGroupIngress",
                    "ec2:CopyImage",
                    "ec2:CreateInternetGateway",
                    "ec2:CreateKeyPair",
                    "ec2:CreateNatGateway",
                    "ec2:CreateNetworkAcl",
                    "ec2:CreateNetworkInterface",
                    "ec2:CreateRoute",
                    "ec2:CreateRouteTable",
                    "ec2:CreateSecurityGroup",
                    "ec2:CreateSnapshot",
                    "ec2:CreateSubnet",
                    "ec2:CreateTags",
                    "ec2:CreateVolume",
                    "ec2:CreateVpc",
                    "ec2:DeleteInternetGateway",
                    "ec2:DeleteKeyPair",
                    "ec2:DeleteNatGateway",
                    "ec2:DeleteNetworkAcl",
                    "ec2:DeleteNetworkInterface",
                    "ec2:DeleteRoute",
                    "ec2:DeleteRouteTable",
                    "ec2:DeleteSecurityGroup",
                    "ec2:DeleteSnapshot",
                    "ec2:DeleteSubnet",
                    "ec2:DeleteTags",
                    "ec2:DeleteVolume",
                    "ec2:DeleteVpc",
                    "ec2:DescribeAccountAttributes",
                    "ec2:DescribeAddresses",
                    "ec2:DescribeAvailabilityZones",
                    "ec2:DescribeFpgaImages",
                    "ec2:DescribeImageAttribute",
                    "ec2:DescribeImages",
                    "ec2:DescribeInstanceAttribute",
                    "ec2:DescribeInstances",
                    "ec2:DescribeInstanceStatus",
                    "ec2:DescribeInternetGateways",
                    "ec2:DescribeKeyPairs",
                    "ec2:DescribeNatGateways",
                    "ec2:DescribeNetworkAcls",
                    "ec2:DescribeNetworkInterfaceAttribute",
                    "ec2:DescribeNetworkInterfaces",
                    "ec2:DescribeRouteTables",
                    "ec2:DescribeSecurityGroups",
                    "ec2:DescribeSnapshots",
                    "ec2:DescribeSubnets",
                    "ec2:DescribeTags",
                    "ec2:DescribeVolumes",
                    "ec2:DescribeVolumeStatus",
                    "ec2:DescribeVpcs",
                    "ec2:DetachInternetGateway",
                    "ec2:DetachNetworkInterface",
                    "ec2:DetachVolume",
                    "ec2:DisassociateAddress",
                    "ec2:DisassociateIamInstanceProfile",
                    "ec2:DisassociateRouteTable",
                    "ec2:DisassociateSubnetCidrBlock",
                    "ec2:ModifyFpgaImageAttribute",
                    "ec2:ModifyImageAttribute",
                    "ec2:ModifyInstanceAttribute",
                    "ec2:ModifyNetworkInterfaceAttribute",
                    "ec2:ModifySubnetAttribute",
                    "ec2:ModifyVpcAttribute",
                    "ec2:MonitorInstances",
                    "ec2:ReleaseAddress",
                    "ec2:ReportInstanceStatus",
                    "ec2:RunInstances",
                    "ec2:StartInstances",
                    "ec2:StopInstances",
                    "ec2:TerminateInstances",
                    "elasticloadbalancing:AddTags",
                    "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
                    "elasticloadbalancing:AttachLoadBalancerToSubnets",
                    "elasticloadbalancing:ConfigureHealthCheck",
                    "elasticloadbalancing:CreateAppCookieStickinessPolicy",
                    "elasticloadbalancing:CreateLBCookieStickinessPolicy",
                    "elasticloadbalancing:CreateLoadBalancer",
                    "elasticloadbalancing:CreateLoadBalancerListeners",
                    "elasticloadbalancing:CreateLoadBalancerPolicy",
                    "elasticloadbalancing:DeleteLoadBalancer",
                    "elasticloadbalancing:DeleteLoadBalancerListeners",
                    "elasticloadbalancing:DeleteLoadBalancerPolicy",
                    "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
                    "elasticloadbalancing:DescribeInstanceHealth",
                    "elasticloadbalancing:DescribeLoadBalancerAttributes",
                    "elasticloadbalancing:DescribeLoadBalancerPolicies",
                    "elasticloadbalancing:DescribeLoadBalancerPolicyTypes",
                    "elasticloadbalancing:DescribeLoadBalancers",
                    "elasticloadbalancing:DescribeTags",
                    "elasticloadbalancing:DetachLoadBalancerFromSubnets",
                    "elasticloadbalancing:DisableAvailabilityZonesForLoadBalancer",
                    "elasticloadbalancing:EnableAvailabilityZonesForLoadBalancer",
                    "elasticloadbalancing:ModifyLoadBalancerAttributes",
                    "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
                    "elasticloadbalancing:RemoveTags",
                    "elasticloadbalancing:SetLoadBalancerListenerSSLCertificate",
                    "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer",
                    "elasticloadbalancing:SetLoadBalancerPoliciesOfListener",
                    "iam:AddRoleToInstanceProfile",
                    "iam:AttachRolePolicy",
                    "iam:CreateInstanceProfile",
                    "iam:CreatePolicy",
                    "iam:CreatePolicyVersion",
                    "iam:CreateRole",
                    "iam:CreateServiceLinkedRole",
                    "iam:DeleteInstanceProfile",
                    "iam:DeletePolicy",
                    "iam:DeletePolicyVersion",
                    "iam:DeleteRole",
                    "iam:DeleteRolePolicy",
                    "iam:DeleteServiceLinkedRole",
                    "iam:DetachRolePolicy",
                    "iam:GetInstanceProfile",
                    "iam:GetPolicy",
                    "iam:GetPolicyVersion",
                    "iam:GetRole",
                    "iam:GetRolePolicy",
                    "iam:ListAttachedRolePolicies",
                    "iam:ListEntitiesForPolicy",
                    "iam:ListInstanceProfiles",
                    "iam:ListInstanceProfilesForRole",
                    "iam:ListPolicies",
                    "iam:ListPolicyVersions",
                    "iam:ListRolePolicies",
                    "iam:ListRoles",
                    "iam:PassRole",
                    "iam:RemoveRoleFromInstanceProfile",
                    "s3:*",
                    "sts:GetCallerIdentity"
                ],
                "Resource": "*"
            }
        ]
    }
    ```

1.  Your policy should look something like this:

	![jsonpolicy](../../../images/install/awsaccount/json_policy.png)

1.  Select **Review Policy**.
2.  Give your policy a name and description and select **Create policy**.

	![policyreview](../../../images/install/awsaccount//policy_review.png)

	
1. Click **Users** from the Navigation and **Add user**.

	![newuser](../../../images/install/awsaccount/newuser.png)

1.  Select `Programmatic access` for the **Access Type** and Click on **Next: Permission** at the bottom of the page.

	![adduser](../../../images/install/awsaccount/add_user.png)

1.  Create a new group for permissions by selecting **Create group**.

	![newgroup](../../../images/install/awsaccount/new_group.png)


 

1. Click **Refresh** and search for the policy you just created `CS_Install_Policy`. Click the checkbox by the policy name and give your group a name.  Select **Create Group**.

	![cs_install_group](../../../images/install/awsaccount/cs_install_group.png)
	
1. With group selected click **Next: Tags** from the Add user screen.

	![usernext](../../../images/install/awsaccount/user_next.png)

1. Add any optional tags and select **Next: Review**.

1. Select **Create user** to finalize to user creation.

1. The `Access key ID` and `Secret access key` will be used for the CS Installer.  

	![keyinfo](../../../images/install/awsaccount/keyinfo.png)


		

	
	
	