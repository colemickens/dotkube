NOTPARALLEL:

all:
	echo "please specify a command"
	true

#$(eval NAMESPACE ?= polykube-$(VERSION))

prep:
	$(eval TEMPDIR = $(shell mktemp -d))
	$(eval VERSION ?= $(shell git describe --always --dirty))
	$(eval NAMESPACE ?= polykube)
	$(eval REPO ?= localhost:5000/)
	$(eval REDIS_PASSWORD ?= $(shell cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1 | base64 -w 0))
	$(eval POSTGRES_PASSWORD ?= $(shell cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1 | base64 -w 0))
	cp -r polykube kube-system $(TEMPDIR)/
	find "$(TEMPDIR)" -name "*.yaml" -print0 | xargs -0 sed -i -e "s|{{namespace}}|$(NAMESPACE)|g"
	find "$(TEMPDIR)" -name "*.yaml" -print0 | xargs -0 sed -i -e "s|{{repo}}|$(REPO)|g"
	find "$(TEMPDIR)" -name "*.yaml" -print0 | xargs -0 sed -i -e "s|{{postgres_password}}|$(POSTGRES_PASSWORD)|g"
	find "$(TEMPDIR)" -name "*.yaml" -print0 | xargs -0 sed -i -e "s|{{redis_password}}|$(REDIS_PASSWORD)|g"
	find "$(TEMPDIR)" -name "*.yaml" -print0 | xargs -0 sed -i -e "s|{{version}}|$(VERSION)|g"

deploy-kube-system:
	kubectl apply -f ./kube-system/namespace.yaml
	kubectl apply -f ./kube-system/kube-proxy.yaml
	kubectl apply -f ./kube-system/kube-dns.yaml
	kubectl apply -f ./kube-system/kubernetes-dashboard.yaml
	kubectl apply -f ./kube-system/kube-registry.yaml

deploy-polykube: prep
	kubectl apply -f $(TEMPDIR)/polykube/namespace.yaml
	kubectl apply -f $(TEMPDIR)/polykube/redis.yaml
	kubectl apply -f $(TEMPDIR)/polykube/postgres.yaml
	kubectl apply -f $(TEMPDIR)/polykube/frontend.yaml
	kubectl apply -f $(TEMPDIR)/polykube/aspnet-api.yaml

clean-kube-system:
	kubectl delete deployment --namespace=kube-system kube-dns kube-registry kubernetes-dashboard || true
	kubectl delete service --namespace=kube-system kube-dns kube-registry kubernetes-dashboard || true
	kubectl delete daemonset --namespace=kube-system kube-registry-proxy || true

# lets us keep our external ips. deleting ns tears it all down
clean-polykube:
	$(eval NAMESPACE ?= polykube)
	kubectl delete --namespace $(NAMESPACE) deployment aspnet-api frontend postgres redis
