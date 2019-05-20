+++
title = "Helm Support for Critical Stack"
date = 2019-04-23T09:43:37-04:00
weight = 6
chapter = false
pre = "<i class='fas fa-toolbox'></i> &nbsp;"
+++

## Helm Chart Support for Critical Stack

### Getting Started
Pre-requisites:
1. A Critical Stack cluster
1. Master node with access to the Internet for helm, helm charts, and Docker images

### Overview
This document describes how to deploy **helm** to support deployment of **helm chart**-based applications.

Note that the next version of **helm** will not include **tiller** so steps to deploy will change significantly (expected to be much simpler and more secure).

### Steps
1. [SSH to master node](../ssh_master_node/)

1. Get helm
```sh
curl -f https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > /tmp/get_helm.sh
sudo sh /tmp/get_helm.sh
sudo helm init	# --tiller-tls-verify
```

2. Fix **RBACs**
```sh
sudo kubectl create serviceaccount --namespace kube-system tiller
sudo kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
sudo kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
```

3. Sync number of replicas (1:1 to number of master nodes).  Re-run this step if you change the number of master nodes.
```sh
sudo kubectl -n kube-system scale deployment/tiller-deploy --replicas=$(kubectl get nodes --selector='node-role.kubernetes.io/master' | grep -v '^NAME ' | wc -l)
```

4. Deploy **helm charts**, e.g., **jenkins**
```sh
sudo helm install stable/jenkins --namespace development
```

### Follow-up
1. Enable `--tiller-tls-verify` [for better security](https://github.com/helm/helm/blob/master/docs/securing_installation.md)

### Troubleshooting tips
1. To uninstall helm client and tiller server, first try:
```sh
sudo helm reset --force
```

2. Delete tiller server deployment
```sh
sudo kubectl -n kube-system delete deployment tiller-deploy
```

3. Delete tiller server replicaset (old style tiller)
```sh
sudo kubectl -n kube-system delete replicaset tiller-deploy-     # use <ESC> to complete
```

4. Delete tiller server pod
```sh
sudo kubectl -n kube-system delete pod tiller-deploy-     # use <ESC> to complete
```

5. Uninstall helm chart, delete pods, delete helm release
```sh
sudo helm delete <chart> --purge
```

