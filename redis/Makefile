.NOTPARALLEL:

CURDIR = $(shell pwd)
REPO ?= localhost:5000/
VERSION ?= $(shell git describe --always --dirty)
IMAGE_FINAL = polykube-redis:$(VERSION)

docker-build-redis:
	docker build -f ./dockerfiles/redis/Dockerfile -t $(IMAGE_FINAL) .

docker-run-redis:
	docker run -it \
		-p 0.0.0.0:6379:6379 \
		$(IMAGE_FINAL)

docker-push: docker-build-redis
	docker tag $(IMAGE_FINAL) $(REPO)$(IMAGE_FINAL)
	docker push $(REPO)$(IMAGE_FINAL)
