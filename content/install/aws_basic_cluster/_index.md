+++
title = "AWS Basic Cluster"
date = 2019-04-23T09:43:37-04:00
weight = 6
chapter = true
pre = "<i class='fas fa-server'></i> "
+++

# Installing Critical Stack into an AWS account
This document provides guidance with the installation of Critical Stack into an AWS account.  

## Prerequisites
- An AWS account
- An AWS _Access key ID_ and _Secret access key_
- Instructions for setting up a new account and access keys - see [AWS Account Setup](../awsaccount)


## Account Setup

1.  Register for a new account at [portal.criticalstack.com](https://portal.criticalstack.com). 

1. Select **Register** from the link at the bottom of the page.

	![register](../../images/install/aws_basic_cluster/register.png)

1. Read the **Terms of Service** and if you agree click **Accept**. 

1. Select a **registration type**.  If the cloud service provider (CSP) account into which Critical Stack will be installed is owned by and paid for by a registered business, click the "Business" registration type. Otherwise, select "Individual".  

	![registrationtype](../../images/install/aws_basic_cluster/registration_type.png)
	
1.  After you fill our your user information click **Register**, you will receive a Welcome Email and a link to confirm your email.

1.  Login to your account at [Critical Stack Developer Portal](https://portal.criticalstack.com).  In the **Key Generator** section, click **Generate License** button to produce a valid license key.  Select `Cloud` as the License Type since we are installing into AWS.  

	![licensetype](../../images/install/aws_basic_cluster/license_type.png)

1. After generating a license key, click the **Go to Installer** button at the top right of the page to run the Critical Stack installer in your AWS environment.  By logging into the installer, the system will automatically link your account’s generated license key to your Critical Stack instance.  

## Installation

1.  There are two types of installations: Cloud and Local.  For this walkthrough, we will be installing in AWS so select `Cloud` and your license key and click **Proceed**.

	![installation_type](../../images/install/aws_basic_cluster/installation_type.png)
	
1. Select your Cloud provider, `AWS`
1. Enter your AWS Credentials to create and configure the required resources.  It is strongly recommended you create a limited access role.  You can use this [sample json definition](../../res/cs_minimum_policy_install.json) to create a policy for your user/group.  Additional information for creating IAM Policies and generating keys can be found [here](../awsaccount)	
1. Select your AWS Region for this cluster and click **Proceed**.

	![provider](../../images/install/aws_basic_cluster/provider.png)
1. You may add any optional **Cluster Tags** and click **Proceed**.

1. If you want to customize the network settings you can add your own **VPC CIDR** and **Subnets** or use the default.  Click on **Proceed**.   Additional details on VPCs and Subnets can be found [here](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html#vpc-sizing-ipv4)

1. Choose what **Instance Type** you want for your Master Node. For detailed comparison ECS instance types this [guide](https://aws.amazon.com/ec2/instance-types) is very helpful.  

1. Choose `Public` for the subnet type unless you are connecting to a private subnet with a VPN.

1. Choose what type of Storage you want to use, either `gp2` General Purpose SSD volume (balance of price and performance) or `io1` Highest-Performance SSD volume (low-latency / high throughput workloads) and the **storage size**.  Select **Proceed**.

	![instancetype](../../images/install/aws_basic_cluster/instance_type.png)
	
1.  Review the cluster settings.  If you need to make any changes you can use the **Go Back** button or click on a section header in the sidebar to make the desired changes.  **Note** The `access_key_id` and `secret_access_key` will not be stored and is only showed for you convenience to verify.  If everything looks correct, click on **Create Cluster**
	![createcluster](../../images/install/aws_basic_cluster/create_cluster.png)
1. When you cluster is ready, select **Download Assets** to get the details about your environment.  
	![installcomplete](../../images/install/aws_basic_cluster/install_complete.png)
	

## Cluster Assets

The **Cluster Assets** page lists the `Cluster information`, `PEM Key`, and and `Cluster Link`.  If you plan to `ssh` into the cluster nodes, you should download they PEM Key.  You can come back to this page at any time if you need to access the cluster information.  

1.  To access the Critical Stack cluster click the **Go To Cluster** button or copy the url provided in the Cluster Link section.

##  TODO -  Add login info after May 15