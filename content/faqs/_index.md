+++
title = "FAQ"
date = 2019-04-23T09:43:37-04:00
weight = 5
chapter = true
pre = "<i class='fas fa-question-circle'></i> "
+++

## What is Critical Stack?

Critical Stack is the secure container orchestration platform for the enterprise. Critical Stack allows you to enforce security, compliance, and regulatory controls for your business while optimizing the efficiency, scalability, resilience of your environment. The Critical Stack orchestration platform is the secure, automated and simple way to manage your infrastructure and deploy containerized workloads on which your company depends.

## What Is Critical Stack's Relationship With Kubernetes?
While Kubernetes is a scalable, resilient, and low-latency container orchestration platform, it does not offer an easy-to-use interface or security and compliance configurations that highly regulated enterprises expect. In response to this need, Critical Stack built a robust set of features that enable enterprises to more easily adopt and secure containerized infrastructure at scale.

Critical Stack does not fork the Kubernetes source code and we do not do anything proprietary to YAML-based configurations used in Kubernetes. Critical Stack starts with Kubernetes and add our internal standards around regression testing, security, or performance.

## How much does Critical Stack cost?
Developers can utilize Critical Stack for free, up to 5 nodes (cloud resources) within a Critical Stack cluster per month.  Should an environment require more than 5 nodes within a cluster, you can add your credit card information via the Account Management page to upgrade your license to Premium, which charges $5/month for each additional node spun up within that month.  Your monthly bill will be calculated based on the total number of new nodes spun up in a calendar month, not the number of nodes active at any given time.  For example, if a customer with 5 nodes in February spins up 2 additional nodes in March and then deactivated 1 prior to the end of the billing cycle, they will be charged $10 at the end of March.

Please note that AWS costs for any nodes spun up within the Critical Stack product are not included in Critical Stack’s pricing/billing. It is your responsibility to pay your cloud provider directly.

In the future, Critical Stack plans to offer an enhanced, enterprise tier of its software that addresses more complex environments. More information will be released on that offering at a later date. 

## What Are Critical Stack's Most Distinguishing Features And Architecture?

### Opinionated Choices About Kubernetes

Critical Stack’s opinionated implementation of Kubernetes is designed to increase security, improve performance, and make Kubernetes more user-friendly.

In every Critical Stack cluster, we configure the kernel to reflect our opinions on security and performance down to the lowest levels of the cluster. An example of an opinionated choice related to security is that each Critical Stack cluster is configured with Security-Enhanced Linux (SELinux) to support granular access control security policies. 

As another example, Critical Stack chooses to use a Container Network Interface (CNI) called Cilium, which offers performance enhancements through the use of Berkeley Packet Filtering (BPF). In addition to performance, Cilium also gives us security features such as the ability to configure Network Security Policies at the layer 7 protocol level.

### Security Features

Critical Stack includes the following features: 

* Executing processes can be secured through Critical Stack using container aware SELinux Policies. 
* Intra-namespace and Inter-namespace communications can be secured with orchestration aware layer 3 and 4 policies.
* Layer 7 protocol analyzers allow the enforcement of granular API security.
* Admission controllers can be used to ensure executing services comply with all required organizational policy.
* The Critical Stack API and User Interface (UI) use JSON Web Tokens for authentication and authorization (a popular authentication mechanism for web interchange).

In the future, real-time dynamic risk scoring will allow organizations to measure and react to a dynamic risk environment.

### User Interface
The Critical Stack User Interface allows for immediate monitoring of the nodes and the containers and pods within in the cluster. Creating new components within the cluster is very easy with the simple wizards, and the advanced editors that provide yaml editing and formatting.

### RESTful API
While the UI is easy to use, the API allows for automation to be built into your CI/CD pipeline.  Every functionality the UI provides is exposed through the API.

### Marketplace
Besides keeping your container cluster secure, another prominent feature Critical Stack offers is its Marketplace. The Critical Stack Marketplace provides a public repository that houses published, pre-configured stacks (app specs) that Critical Stack users can replicate/install into their clusters.

In the future, the Marketplace will allow Critical Stack customers to submit their own app specs to the Critical Stack Marketplace for review, vetting, and (if accepted) publication into the public Marketplace.  Additionally, Critical Stack will soon support companies publishing to their own private marketplaces, enabling developers within their organization to share app specs across clusters and teams. 

### Installer
Critical Stack has a click-through installer that enables installation of Critical Stack into a new VPC within your AWS account in a matter of minutes.

## How Does Critical Stack Compare To Other Alternatives?
When comparing containerization to non-containerized workloads,containerization reduces the attack surface, while also providing security, portability, and efficiency.

When comparing Critical Stack to other container orchestration solutions, Critical Stack offers a container orchestration solution that is “by the enterprise, for the enterprise”. Critical Stack is engineered for complex, regulated environments (like Capital One) with a focus on providing a container orchestration solution that can truly address all the jobs to be done at the enterprise level.

Lastly, for those who are interested in or using serverless computing, while a serverless architecture may work for many workloads, most serverless solutions available in the industry today are not as portable as containerized solutions.  Given containerization (and Critical Stack) do not rigidly lock in customers to a specific architecture or product, customers can get all of the benefits of containerization (and most of the benefits of serverless) without handcuffing themselves to the solution.

## Does/How-Does Critical Stack Integrate With An Aspect Of My Existing Solution?
Critical Stack is enterprise software, not SaaS. This means that Critical Stack installs into your AWS cloud environment. Once the Critical Stack software is installed, you will have the ability to manage your infrastructure and deploy workloads within the software.

As an example, within Capital One’s enterprise environment, Critical Stack has integrated with (or is in the process of integrating with) standard patterns and practices such as (but not limited to):

* Building Containerized Microservices
* Transforming Monoliths into Containerized Microservices
* CI/CD Pipelines
* Metrics Collection/Aggregation
* Log Aggregation
* Monitoring
* Audit Logging
* Open Policy Agent (OPA)
* High Availability
* Autoscaling
* Vault/Secrets Integration
* Single Sign On (SSO)

The Critical Stack team is working to publish share-able content for these Patterns & Practices on Critical Stack.

## How Does Critical Stack Support And Integrate With The Cloud?
Critical Stack is installable within all US Amazon Web Services (AWS) regions, with all standard functionality and cloud resources available to workloads running on Critical Stack. 

As part of our future roadmap, we plan to make Critical Stack compatible with other cloud providers such as Azure, GCP and Digital Ocean.

## Can I Use Critical Stack On-Premises?
Critical Stack does not have an on-prem solution available today. As part of our future roadmap, we will look at producing an on-prem solution.  Please submit any on-premise feature requests and suggestions to support@criticalstack.com. 

## I'm Not That Familiar with Containers Or Container Orchestration Where Can I Go To Learn More
[A Beginner-Friendly Introduction to Containers, VMs, and Docker](https://medium.freecodecamp.org/a-beginner-friendly-introduction-to-containers-vms-and-docker-79a9e3e119b)

[How to Choose the Right Container Orchestration and How to Deploy It](https://medium.freecodecamp.org/how-to-choose-the-right-container-orchestration-and-how-to-deploy-it-41844021c241)

[A Kubernetes FAQ for the C-Suite](https://cloud.google.com/blog/products/containers-kubernetes/kubernetes-faq-for-the-c-suite)

[Learn Kubernetes in Under 3 Hours: A Detailed Guide to Orchestrating Containers](https://medium.freecodecamp.org/learn-kubernetes-in-under-3-hours-a-detailed-guide-to-orchestrating-containers-114ff420e882)

