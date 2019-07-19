+++
title = "Kubectl 101"
date = 2019-04-23T09:43:37-04:00
weight = 6
chapter = false
pre = "<i class='fas fa-toolbox'></i> &nbsp;"
+++



## Kubectl 101

### Getting Started
Pre-requisites:

1. A Critical Stack cluster.  You will need to know the admin username and password.  
1. kubectl installed : [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl)


## Getting Started 
Source material for this introduction borrowed from [kubernetes.io](https://kubernetes.io/docs/reference/kubectl/overview/) documentation.

Kubectl is a command line interface for running commands against Kubernetes clusters. This overview covers kubectl syntax, describes the command operations, and provides common examples. For details about each command, including all the supported flags and subcommands, see the kubectl reference documentation. 

Use the following syntax to run **kubectl** commands from your terminal window:

```session
kubectl [command] [TYPE] [NAME] [flags]
```

where **command**, **TYPE**, **NAME**, and **flags** are:

  - **command** Specifies the operation that you want to perform on one or more resources, for example _create_, _get_, _describe_, _delete_.
  - **Type**: Specifies the [resource type](https://kubernetes.io/docs/reference/kubectl/overview/#resource-types).  Some examples are : pods, nodes, services, deployments. Resource types are case-insensitive and you can specify the singular, plural, or abbreviated forms. For example, the following commands produce the same output:

  	```session
 	 kubectl get pod pod1
 	 kubectl get pods pod1
  	 kubectl get po pod1
 	```

  - **NAME**:  Specifies the name of the resource. Names are case-sensitive. If the name is omitted, details for all resources are displayed.  
  - **flags**: Specifies optional flags. For example, you can use the -s or --server flags to specify the address and port of the Kubernetes API server.


## Connecting to your server

### kubectl Config Files

A config file, typically stored in `~/.kube/config`, defines the cluster, user, and namespace to use for each `kubectl` command. This guide will walk through creating a new config file for a Critical Stack cluster.  If you are already using minikube or another kubernetes cluster, follow this guide for [multiple clusters](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/).  


Create a file called `~/.kube/config`, and place this header at the top:
```
apiVersion: v1
kind: Config
preferences: {}
```

### Info about your cluster

On a new line, create the tag `clusters:`, and create a `cluster:` tag as a child. Name the cluster something familiar, and provide its URL as `server:` under `cluster:`.  The Secure port is `6443`
```
apiVersion: v1
kind: Config
preferences: {}
clusters:
- cluster:
    server: https://CS-Cluster-61010-elb-1512390147.us-east-1.elb.amazonaws.com:6443
  name: example-cluster
```

### Your login info

Create a `users:` block, and a `user:` object as a child. Name that user, and provide your authentication information. You'll be authenticating with a token, which you can find in Critical Stack by going to the cluster admin's namespace (top right hand corner) then to "Config" then "Secrets". You'll see a secret named `<adminnamespace>-token-<random id>`. Don't use the token labeled `default-token-<random id>`, as this token will not work. Click that token name, and you'll see a clipboard icon to copy `token`. This is your `kubectl` authentication token.  Copy the ca.crt content and create a new file locally.  You will reference the `certificate-authority` as well.

```
apiVersion: v1
kind: Config
preferences: {}
clusters:
- cluster:
    server: https://CS-Cluster-61010-elb-1512390147.us-east-1.elb.amazonaws.com:6443
    certificate-authority: /Users/testuser/ca.crt
  name: example-cluster
users:
- name: example-user
  user:
    token: <your token here>
```

## Using your cluster
A context describes how to use your cluster. Create a `contexts:` block, then a `context:` as a child. Name the context, and provide the `cluster`, `namespace`, and `user`. Then, set your `current-context:` to the context you just created.

```
apiVersion: v1
clusters:
- cluster:
    certificate-authority: /Users/hee617/.ssh/cs-cluster-ca.crt
    server: https://CS-Cluster-61010-elb-1532390197.us-east-1.elb.amazonaws.com
  name: cs-cluster
contexts:
- context:
    cluster: cs-cluster
    user: clusteradmin
  name: cs-cluster
current-context: cs-cluster
kind: Config
preferences: {}
users:
- name: clusteradmin
  user:
    token: 
```

1. By default `kubectl` uses the configuration in $HOME/.kube/config.  If you want to run commands against multiple servers (CS or minikube) you will need a [multi config file](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/) or use **Environment** variables. 

1. To view your current config you can run this command:

	`kubectl config view`

## Basic commands

1. Lets test our a few commands and compare with what we see in the UI. 

	`kubectl get pods`
	
	```
	$ kubectl get pods
	NAME                                   READY     STATUS    RESTARTS   AGE
	hello-go-deployment-85b5b5cc6f-9h4wh   1/1       Running   0          4d
	hello-go-deployment-85b5b5cc6f-ccsd5   1/1       Running   0          4d
	hello-go-deployment-85b5b5cc6f-s6htw   1/1       Running   0          5d
	```

	![getpods](../../images/getpods.png)

1. **Note** you will have have access to the resource types that your have permission to view/create within your namespace. If you are the cluster admin you will have permission to see all namespaces and resources.

1.  In this example, I have 3 pods running all from one deployment.  Let's take a look at the deployment:

	`kubectl get deployments`
	
	```session
	$ kubectl get deployments
	NAME                  DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
	hello-go-deployment   3         3         3            3           6d
	```
	
	![getdeployment](../../images/getdeployment.png)
	
1.  To view the configuration for this deployment, run this command:

	`kubectl describe deployment`
	
	```session
	$ kubectl describe deployment
	Name:                   hello-go-deployment
	Namespace:              <namespace>
	CreationTimestamp:      Wed, 17 Apr 2019 10:18:24 -0400
	Labels:                 app=hello-go
	Annotations:            deployment.kubernetes.io/revision=3
	Selector:               app=hello-go
	Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
	StrategyType:           RollingUpdate
	MinReadySeconds:        0
	RollingUpdateStrategy:  1 max unavailable, 1 max surge
	Pod Template:
	  Labels:  app=hello-go
	  Containers:
	   hello-go:
	    Image:        jabbottc1/hello-go:0.0.3
	    Port:         8080/TCP
    ```

1.  Let's change the `replicas` value of the deployment.  You could do this from the UI, but we will change this from the command line.

	`kubectl scale deployment hello-go-deployment --replicas=2`
	
	```session
	$ kubectl scale deployment hello-go-deployment --replicas=2
	kubectl describe deployment
	Name:                   hello-go-deployment
	Namespace:              <namespace>
	CreationTimestamp:      Wed, 17 Apr 2019 10:18:24 -0400
	Labels:                 app=hello-go
	Annotations:            deployment.kubernetes.io/revision=3
	Selector:               app=hello-go
	Replicas:               2 desired | 2 updated | 2 total | 2 available | 0 	unavailable
	StrategyType:           RollingUpdate
	MinReadySeconds:        0
	RollingUpdateStrategy:  1 max unavailable, 1 max surge
	Pod Template:
  	Labels:  app=hello-go
  	```

## Conclusion 

You have successfully setup **kubectl** with your Critical Stack cluster and can run some basic commands to view and update existing resources.

