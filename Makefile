all:

prep:
	$(eval VERSION ?= $(shell git describe --always --dirty))
	$(eval export VERSION)

# This probably will never be used by Jenkins
# Because we want the parallelism to be done in Jenkins

aspnet: prep
	$(MAKE) -C aspnet docker-push > aspnet.build.log 2>&1
redis: prep
	$(MAKE) -C redis docker-push > redis.build.log 2>&1
postgres: prep
	$(MAKE) -C postgres docker-push > postgres.build.log 2>&1
frontend: prep
	$(MAKE) -C frontend docker-push > frontend.build.log 2>&1

push: aspnet redis postgres frontend

deploy: push
	$(MAKE) -C kubernetes deploy-polykube
