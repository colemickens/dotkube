.NOTPARALLEL:

CURDIR = $(shell pwd)
REPO ?= localhost:5000
VERSION ?= $(shell git describe --always --dirty)
IMAGE_FINAL = $(REPO)/polykube-postgres:$(VERSION)

docker-build-postgres:
	docker build -f ./dockerfiles/postgres/Dockerfile -t $(IMAGE_FINAL) .

docker-run-postgres:
	docker run -it \
		-p 0.0.0.0:5432:5432 \
		$(IMAGE_FINAL)

docker-push: docker-build-postgres
	docker push $(IMAGE_FINAL)
