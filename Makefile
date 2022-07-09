VERSION_FILE := $(SERVICE)/version.txt
IMAGE_NAME := myownradio/$(SERVICE)
IMAGE_TAG := $(shell ([ -r ${VERSION_FILE} ] && (cat ${VERSION_FILE} | sed 's/[[:space:]]//g')) || echo "latest")
PORT := 8080

build: check-env
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) ./$(SERVICE)

push: check-env
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(IMAGE_NAME):latest
	docker push $(IMAGE_NAME):$(IMAGE_TAG)
	docker push $(IMAGE_NAME):latest

inspect:
	docker run -it --rm -p ${PORT}:8080 $(IMAGE_NAME):$(IMAGE_TAG) sh

check-env:
	@test -n "$(SERVICE)" || (echo SERVICE is undefined && exit 1)
