## helm chart support for Critical Stack
### Getting Started
Pre-requisites:
1. A Critical Stack cluster
1. Master node with access to the Internet for helm, helm charts, and Docker images

### Overview
This document describes how to deploy _**helm**_ to support deployment of _**helm chart**_-based applications.  Impetus for work is to begin _**KATO**_ integration work.

What is described here should be considered proof-of-concept as I didn't take the implementation to conclusion given the product team may be adding _**helm**_ support by decomposing the _**helm charts**_ and applying via _**kubectl**_ instead of feeding to _**tiller**_ .

### Steps
Run steps as root / sudo (to get _**kubeconfig**_) unless indicated otherwise
1. Get helm
```sh
curl -f https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > /tmp/get_helm.sh
sh /tmp/get_helm.sh
helm init	# --tiller-tls-verify
```

2. Fix _**RBACs**_
```sh
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
```

3. Increase number of replicas (1:1 to number of masters) so typically 3 replicas`
```sh
kubectl -n kube-system scale deployment/tiller-deploy --replicas=3
```

4. Deploy _**helm charts**_, e.g., _**jenkins**_
```sh
helm install stable/jenkins --namespace development
```

5. HACK (for example _**jenkins**_ helm chart):  edit _**jenkins**_ Deployment and change _**CPU**_ requests from `100ms` to `50ms`


### Follow-up
1. If using _**tiller**_, RBAC configuration may need a closer eye.
1. Enable `--tiller-tls-verify`
1. Fix _**Limit Ranges**_ instead of hacking Deployment
1. If master nodes can't access the Internet as I suspect internal cluster deployments can't, work through that.  Really just need Internet access to deploy helm itself and test with an internal helm chart repo.  That could be downloaded and copied to the master node separately.

### Troubleshooting tips
1. To uninstall helm client and tiller server, first try:
```sh
helm reset --force
```

2. Delete tiller server deployment
```sh
kubectl -n kube-system delete deployment tiller-deploy
```

3. Delete tiller server replicaset (old style tiller)
```sh
kubectl -n kube-system delete replicaset tiller-deploy-     # use <ESC> to complete
```

4. Delete tiller server pod
```sh
kubectl -n kube-system delete pod tiller-deploy-     # use <ESC> to complete
```

5. Uninstall helm chart, delete pods, delete helm release
```sh
helm delete xxx --purge
```
