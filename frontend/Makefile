#!/bin/bash

.NOTPARALLEL:

CURDIR = $(shell pwd)
REPO ?= localhost:5000/
VERSION ?= $(shell git describe --always --dirty)
IMAGE_FINAL = polykube-www:$(VERSION)
IMAGE_BUILD = polykube-www-builder
IMAGE_DEVENV = polykube-www-devenv

build:
	(\
	cd www; \
	rm -rf dist; \
	npm install; \
	npm run postinstall; \
	ng build -prod; \
	)

dev:
	(\
	cd www; \
	ng serve --host 0.0.0.0 --port 9999 --live-reload-host 0.0.0.0 --live-reload-port 9998; \
	)

tar-out:
	tar -cf - ./dockerfiles/www-nginx/ ./www/dist/

# the builder relies on devenv image
docker-build-www-builder: docker-build-www-devenv
	docker build \
		-f ./dockerfiles/www-builder/Dockerfile \
		-t $(IMAGE_BUILD) \
		.

docker-build-www: docker-build-www-builder
	docker run $(IMAGE_BUILD) | \
		docker build \
			-f ./dockerfiles/www-nginx/Dockerfile \
			-t $(IMAGE_FINAL) \
			-

docker-build-www-devenv:
	docker build \
		-f ./dockerfiles/www-dev/Dockerfile \
		-t $(IMAGE_DEVENV) \
		.

docker-run-www: docker-build-www
	docker run -it \
		-p 0.0.0.0:9999:80 \
		$(IMAGE_FINAL)

docker-devenv: docker-build-www-devenv
	docker run -it \
		-p 0.0.0.0:9999:9999 \
		-p 0.0.0.0:9998:9998 \
		-v $(CURDIR):/opt/polykube \
		$(IMAGE_DEVENV) /bin/bash; true

docker-push: docker-build-www
	docker tag $(IMAGE_FINAL) $(REPO)$(IMAGE_FINAL)
	docker push $(REPO)$(IMAGE_FINAL)
