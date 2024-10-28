VERSION = 3.0.1
IMG_REPO = docker.io
OWNER = pmarinov944
DISABLE_OPTIMIZATIONS = 0
IMAGE = $(IMG_REPO)/$(OWNER)/holy-build-box

.PHONY: build_amd64 build_386 build_armv7 build_arm64 build test_amd64 test_386 test_armv7 test_arm64 push_amd64 push_386 push_armv7 push_arm64 export_amd64 export_386 export_armv7 export_arm64 release pull_amd64 pull_386 pull_armv7 pull_arm64 pull

build_amd64:
	docker buildx build --load --platform "linux/amd64" --rm -t $(IMAGE):$(VERSION)-amd64 --pull --build-arg DISABLE_OPTIMIZATIONS=$(DISABLE_OPTIMIZATIONS) .

build_386:
	docker buildx build --load --platform "linux/386" --rm -t $(IMAGE):$(VERSION)-386 --pull --build-arg DISABLE_OPTIMIZATIONS=$(DISABLE_OPTIMIZATIONS) .

build_armv7:
	docker buildx build --load --platform "linux/arm/v7" --rm -t $(IMAGE):$(VERSION)-armv7 --pull --build-arg DISABLE_OPTIMIZATIONS=$(DISABLE_OPTIMIZATIONS) .

build_arm64:
	docker buildx build --load --platform "linux/arm64" --rm -t $(IMAGE):$(VERSION)-arm64 --pull --build-arg DISABLE_OPTIMIZATIONS=$(DISABLE_OPTIMIZATIONS) .

build: build_386 build_amd64 build_armv7 build_arm64

test_amd64:
	docker run -it --platform "linux/amd64" --rm -e SKIP_FINALIZE=1 -e DISABLE_OPTIMIZATIONS=1 -v $$(pwd)/image:/hbb_build:ro centos:centos7 bash /hbb_build/build.sh

test_386:
	docker run -it --platform "linux/386" --rm -e SKIP_FINALIZE=1 -e DISABLE_OPTIMIZATIONS=1 -v $$(pwd)/image:/hbb_build:ro centos:centos7 bash /hbb_build/build.sh

test_armv7:
	docker run -it --platform "linux/arm/v7" --rm -e SKIP_FINALIZE=1 -e DISABLE_OPTIMIZATIONS=1 -v $$(pwd)/image:/hbb_build:ro centos:centos7 bash /hbb_build/build.sh

test_arm64:
	docker run -it --platform "linux/arm64" --rm -e SKIP_FINALIZE=1 -e DISABLE_OPTIMIZATIONS=1 -v $$(pwd)/image:/hbb_build:ro centos:centos7 bash /hbb_build/build.sh

push_amd64:
	docker push $(IMAGE):$(VERSION)-amd64

push_386:
	docker push $(IMAGE):$(VERSION)-386

push_armv7:
	docker push $(IMAGE):$(VERSION)-armv7

push_arm64:
	docker push $(IMAGE):$(VERSION)-arm64

export_amd64:
	docker save -o hbb_amd64.tar $(IMAGE):$(VERSION)-amd64

export_386:
	docker save -o hbb_386.tar $(IMAGE):$(VERSION)-386

export_armv7:
	docker save -o hbb_armv7.tar $(IMAGE):$(VERSION)-armv7

export_arm64:
	docker save -o hbb_arm64.tar $(IMAGE):$(VERSION)-arm64

release: push_amd64 push_armv7 push_arm64 push_386
	docker manifest create $(IMAGE):$(VERSION) $(IMAGE):$(VERSION)-amd64 $(IMAGE):$(VERSION)-armv7 $(IMAGE):$(VERSION)-arm64 $(IMAGE):$(VERSION)-386
	docker manifest push $(IMAGE):$(VERSION)

pull_amd64:
	docker pull $(IMAGE):$(VERSION)-amd64

pull_386:
	docker pull $(IMAGE):$(VERSION)-386

pull_armv7:
	docker pull $(IMAGE):$(VERSION)-armv7

pull_arm64:
	docker pull $(IMAGE):$(VERSION)-arm64

pull: pull_amd64 pull_arm64 pull_armv7 pull_386
