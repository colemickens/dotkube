# polykube demo

It should be possible to provision a Kubernetes cluster on Azure and deploy this application to it in under 15 minutes.

## Deploy Kubernetes Cluster on Azure

1. Run `azkube` or `min-turnup` to get a Kubernetes cluster on Azure. (TODO: Finish these steps)

## Deploy `kube-system` Services to the Cluster

1. `cd kubernetes`

2. `make deploy-kube-system`

## Deploy `dotkube`

1. `cd kubernetes`

2. `make deploy-dotkube`
