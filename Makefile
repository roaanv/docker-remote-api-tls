DOCKER_HOST ?= unseen:6088/
DOCKER_USER ?= roaanv/
IMAGE_NAME = $(DOCKER_HOST)$(DOCKER_USER)docker-api-proxy
CONTAINER_NAME = docker-api-proxy
DATA_DIR ?= /Users/rvos/mycode/docker-remote-api-tls/data/certs

all: build

build: image

image:
	docker build -t $(IMAGE_NAME) .

run_docker: set_daemon container_runner

test_docker: container_runner

container_runner: stop
	-docker run --name $(CONTAINER_NAME) \
    	$(DAEMON_ARG) \
    	-p 8080:8080 \
		-v $(DATA_DIR):/data/certs \
        $(IMAGE_NAME)

	-@sleep 2
	-@docker ps | grep $(CONTAINER_NAME)

set_daemon:
	$(eval DAEMON_ARG=-d)

stop:
	-docker stop $(CONTAINER_NAME)
	-docker rm $(CONTAINER_NAME)

logs:
	-@docker logs $(CONTAINER_NAME)

push: container
	docker push $(IMAGE_NAME):latest
