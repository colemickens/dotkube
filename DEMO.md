# Polykube Demo
  This demo will walk you through deploying [`polykube`](https://github.com/colemickens/polykube).
  This demo will specifically cater to users who are following from [`azure-kubernetes-demo`](https://github.com/colemickens/azure-kubernetes-demo).

  The live version is visible at [polykube.io](http://polykube.io) 
  and [api.polykube.io](http://api.polykube.io/counter).

## Prerequisites

  1. A Kubernetes 1.4 Cluster deployed via [`azure-kubernetes-demo`](https://github.com/colemickens/azure-kubernetes-demo).

  2. `kubectl` installed. [The Kubernetes docker docs page](http://kubernetes.io/docs/getting-started-guides/docker/)
     includes instructions of acquiring the `kubectl` binary. Make it executable
     and put it in your PATH.

## Configure `kubectl`

  The `kubernetes-anywhere` deployment drops a kubeconfig into a temporary dir. 
  We are going to **overwrite ~/.kube/config** for the sake of this demo. You may
  wish to do something else if you have other clusters. Remember that all 
  `kubectl` commands can be changed to `kubectl --kubeconfig=/path/to/kubeconfig`.

  ```shell
  cp ~/kubernetes-anywhere/azure/phase1/.tmp/kubeconfig ~/.kube/config
  ```

## Clone `polykube`

  ```shell
  git clone https://github.com/colemickens/polykube
  cd polykube
  ```

## Deploy `kube-system` Services

  ```shell
  cd kubernetes

  # deploy kube-system namespace, kube-dns, kube-proxy, kube-dashboard
  make deploy-kube-system
  ```

## Port-forward to your cluster-local Docker Registry

  ```shell
  # list all pods in the `kube-system` namespace
  kubectl get pods --namespace=kube-system

  # get the pod name that corresponds to docker-registry (requires `jq`)
  REGISTRY_POD_NAME=$(kubectl get pods --namespace=kube-system -o json | jq -r '.items | map(select(contains ({"metadata":{"labels":{"k8s-app":"kube-registry"}}}))) | .[0].metadata.name')

  # make port 5000 port-forward to 5000 on the cluster-local docker-registry
  kubectl port-forward --namespace=kube-system ${REGISTRY_POD_NAME} 5000
  ```

## Deploy `polykube` 

  Build `polykube` the components to the cluster-local registry via the 
  `kubectl port-forward` tunnel.

  ```shell
  # build polykube-aspnet-api
  # build polykube-frontend
  # build polykube-postgres
  # build polykube-redis
  # push them all to the cluser-local registry
  # deploy the Deployments and Services for `polykube`
  make deploy-polykube
  ```

## See polykube!

  ```shell
  # see the external L4 LoadBalanced IP for the frontend
  kubectl get svc --namespace=polykube frontend
  
  # see the external L4 LoadBalanced IP for the aspnet-api
  kubectl get svc --namespace=polykube aspnet-api
  ```

  You could then wire up DNS and have your instance working identically to the 
  one running at [polykube.io](http://polykube.io).