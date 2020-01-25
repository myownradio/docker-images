IMAGE_NAME := myownradio/$(SERVICE)-image
IMAGE_TAG := latest

build: check-env
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) ./$(SERVICE)

push: check-env
	docker push $(IMAGE_NAME):$(IMAGE_TAG)

check-env:
	@test -n "$(SERVICE)" || (echo SERVICE is undefined && exit 1)
