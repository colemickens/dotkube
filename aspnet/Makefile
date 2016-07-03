.NOTPARALLEL:

CURDIR = $(shell pwd)
REPO ?= localhost:5000
VERSION ?= $(shell git describe --always --dirty)
IMAGE_BUILD = polykube-aspnet-api-builder
IMAGE_FINAL = $(REPO)/polykube-aspnet-api:$(VERSION)
IMAGE_NGINX = $(REPO)/polykube-aspnet-nginx:$(VERSION)

build:
	dotnet restore -v Verbose
	(dotnet -v publish -c Release Api/project.json)

tar-out:
	tar -cf - -C ./dockerfiles/aspnet-api/ ./Dockerfile -C ./../../Api/bin/Release/netcoreapp1.0/debian.8-x64 .

docker-build-aspnet-api-builder:
	docker build \
		-f ./dockerfiles/aspnet-api-builder/Dockerfile \
		-t $(IMAGE_BUILD) \
		.

docker-build-aspnet-api: docker-build-aspnet-api-builder
	docker run $(IMAGE_BUILD) | \
		docker build \
			-f ./Dockerfile \
			-t $(IMAGE_FINAL) \
			-

#TODO: we don't need to send all of the current dir to docker
#      it really only needs the nginx.conf
docker-build-aspnet-api-nginx:
	docker build -f ./dockerfiles/aspnet-nginx/Dockerfile -t $(IMAGE_NGINX) .

docker-run-aspnet-api:
	docker run -it \
		-p 0.0.0.0:8000:8000 \
		$(IMAGE_FINAL)

docker-devenv: docker-build-aspnet-api-builder
	docker run -it \
		-p 0.0.0.0:8000:8000 \
		-v $(CURDIR):/polykube \
		-v $(CURDIR)/.nuget-cache:/root/.local/share/NuGet \
		$(IMAGE_BUILD) /bin/bash

docker-push-aspnet-api: docker-build-aspnet-api
	docker push $(IMAGE_FINAL)

docker-push-aspnet-nginx: docker-build-aspnet-api-nginx
	docker push $(IMAGE_NGINX)

docker-push: docker-push-aspnet-api docker-push-aspnet-nginx
