NOTPARALLEL:

all:
	echo "please specify a command"
	false

# Prep
# set vars and export them for sub-make invocations
prep:
	$(eval TEMPDIR = $(shell mktemp -d))
	$(eval VERSION ?= $(shell git describe --always --dirty))
	$(eval NAMESPACE ?= polykube)
	$(eval REPO ?= localhost:5000)
	$(eval export VERSION)
	$(eval export NAMESPACE)
	$(eval export REPO)

# Push commands
# used to build and push images to the cluster
push-aspnet: prep
	$(MAKE) -C ../aspnet docker-push > ../aspnet.build.log 2>&1
push-redis: prep
	$(MAKE) -C ../redis docker-push > ../redis.build.log 2>&1
push-postgres: prep
	$(MAKE) -C ../postgres docker-push > ../postgres.build.log 2>&1
push-frontend: prep
	$(MAKE) -C ../frontend docker-push > ../frontend.build.log 2>&1
push: push-aspnet push-redis push-postgres push-frontend


# Prep Deploy
# prepare the redis/postgres secrets
prep-deploy: prep
	$(eval REDIS_PASSWORD ?= $(shell cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1 | base64 -w 0))
	$(eval POSTGRES_PASSWORD ?= $(shell cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1 | base64 -w 0))
	cp -r polykube kube-system $(TEMPDIR)/
	find "$(TEMPDIR)" -name "*.yaml" -print0 | xargs -0 sed -i -e "s|{{namespace}}|$(NAMESPACE)|g"
	find "$(TEMPDIR)" -name "*.yaml" -print0 | xargs -0 sed -i -e "s|{{repo}}|$(REPO)|g"
	find "$(TEMPDIR)" -name "*.yaml" -print0 | xargs -0 sed -i -e "s|{{postgres_password}}|$(POSTGRES_PASSWORD)|g"
	find "$(TEMPDIR)" -name "*.yaml" -print0 | xargs -0 sed -i -e "s|{{redis_password}}|$(REDIS_PASSWORD)|g"
	find "$(TEMPDIR)" -name "*.yaml" -print0 | xargs -0 sed -i -e "s|{{version}}|$(VERSION)|g"

deploy-kube-system-core:
	kubectl apply -f ./kube-system/namespace.yaml
	kubectl apply -f ./kube-system/kube-proxy.yaml
	kubectl apply -f ./kube-system/kube-dns.yaml
	kubectl apply -f ./kube-system/kubernetes-dashboard.yaml
	kubectl apply -f ./kube-system/kube-registry.yaml

deploy-kube-system-monitoring:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/grafana-service.yaml
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster-service.yaml
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb-service.yaml
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster-controller.yaml
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb-grafana-controller.yaml

deploy-kube-system-logging:
	kubectl apply -f https://gist.githubusercontent.com/colemickens/68cc04a19ed834c3f038cba0959e9e40/raw/9ef32f28efae8cbe0839c83a3d467fb1c77b13bc/fluentd-elasticsearch-v1-daemonset.yaml
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/kubernetes/master/cluster/addons/fluentd-elasticsearch/es-service.yaml
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/kubernetes/master/cluster/addons/fluentd-elasticsearch/es-controller.yaml
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/kubernetes/master/cluster/addons/fluentd-elasticsearch/kibana-service.yaml
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/kubernetes/master/cluster/addons/fluentd-elasticsearch/kibana-controller.yaml


deploy-kube-system: deploy-kube-system-core deploy-kube-system-monitoring deploy-kube-system-logging

# prep-deploy creates a new secret, so we need to
# delete the deployment first, otherwise the existing redis/postgres
# are using the stale secret and thus new deployments can't connect.
# need to investigate restarting the redis/postgres on secret change?
deploy-polykube: prep-deploy clean-polykube
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
clean-polykube: prep
	kubectl delete --namespace $(NAMESPACE) deployment aspnet-api frontend postgres redis || true
