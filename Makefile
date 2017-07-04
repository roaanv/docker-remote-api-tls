DOCKER_HOST ?= unseen:6088/
DOCKER_USER ?= roaanv/
IMAGE_NAME = $(DOCKER_HOST)$(DOCKER_USER)docker-api-proxy
CONTAINER_NAME = docker-api-proxy
DATA_DIR ?= /Users/rvos/mycode/docker-remote-api-tls/data/certs
CERT_MAKER := bin/create-certs.sh

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
		-v /var/run/docker.sock:/var/run/docker.sock \
        $(IMAGE_NAME)

	-@sleep 2
	-@docker ps | grep $(CONTAINER_NAME)

shell_docker: stop
	-docker exec -it \
    	-p 8080:8080 \
		-v $(DATA_DIR):/data/certs \
        $(IMAGE_NAME) \
		/bin/sh

set_daemon:
	$(eval DAEMON_ARG=-d)

stop:
	-docker stop $(CONTAINER_NAME)
	-docker rm $(CONTAINER_NAME)

logs:
	-@docker logs $(CONTAINER_NAME)

push: container
	docker push $(IMAGE_NAME):latest

certs: cert_ca cert_server cert_client

cert_ca:
	$(CERT_MAKER) -m ca -h unseen.spacehuis.net -pw secret -t data/certs --ca-subj

cert_server:
	$(CERT_MAKER) -m server -hip 192.168.1.41 -h unseen.spacehuis.net -pw secret -t data/certs

cert_client:
	$(CERT_MAKER) -m client -h unseen.spacehuis.net -pw secret -t data/certs

