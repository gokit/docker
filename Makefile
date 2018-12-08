VERSION ?= 0.1
DUSER ?= influx6
COMPONENTS = app-engine-go cbt bigtable datalab cloud-datastore-emulator gcd-emulator cloud-firestore-emulator pubsub-emulator cloud_sql_proxy emulator-reverse-proxy cloud-build-local docker-credential-gcr kubectl
GOVERSION = 1.11.2 1.11.1 1.11 1.10 1.9 1.8 1.7
FROM_NAME='#FROM'

define COMPONENT_DOCKER_FORMAT
FROM #FROM\nARG component\nRUN set -xe && gcloud components install $$component && gcloud components update\n
endef

default: build push

build: build-bases build-google-components tags build-components

build-bases: build-base build-pubsub build-golang build-gcloud-golang

build-components: build-kafka-golang build-nats-golang build-nats-streaming-golang build-redis-golang build-golang-components

build-base:
	docker build -t alpine-base -f Dockerfile-base .
	docker tag alpine-base $(DUSER)/alpine-base:$(VERSION)

build-pubsub:
	docker build -t nats-base -f Dockerfile-nats .
	docker build -t kafka-base -f Dockerfile-kafka .
	docker build -t redis-base -f Dockerfile-redis .
	docker build -t google-cloud-base -f Dockerfile-gcloud .
	docker build -t nats-streaming-base -f Dockerfile-nats-streaming .

build-golang:
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t golang-$(version)-base -f Dockerfile-golang-base .;)

build-redis-golang:
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t redis-golang-$(version)-base -f Dockerfile-redis-golang .;)

build-kafka-golang:
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t kafka-golang-$(version)-base -f Dockerfile-kafka-golang .;)

build-nats-golang:
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t nats-golang-$(version)-base -f Dockerfile-nats-golang .;)

build-nats-streaming-golang:
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t nats-streaming-golang-$(version)-base -f Dockerfile-nats-streaming-golang .;)

build-gcloud-golang:
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t gcloud-golang-$(version)-base -f Dockerfile-gcloud-golang .;)

build-google-components:
	$(foreach component, $(COMPONENTS), docker build --build-arg component=$(component) -t google-$(component)-base -f Dockerfile-google-components .;)

build-golang-components:
	for version in $(GOVERSION); do for component in $(COMPONENTS); do docker build --build-arg component=$$component -t gcloud-golang-$$version-$$component-base -f Dockerfile-gcloud-golang-$$version-components .; done done

golang-component-docker-files:
	$(foreach version, $(GOVERSION), echo '$(subst #FROM,$(DUSER)/gcloud-golang-$(version)-base:$(VERSION),$(COMPONENT_DOCKER_FORMAT))' > Dockerfile-gcloud-golang-$(version)-components;)

tags:
	docker tag nats-base $(DUSER)/nats-base:$(VERSION)
	docker tag kafka-base $(DUSER)/kafka-base:$(VERSION)
	docker tag redis-base $(DUSER)/redis-base:$(VERSION)
	docker tag nats-streaming-base $(DUSER)/nats-streaming-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker tag golang-$(version)-base $(DUSER)/golang-$(version)-base:$(VERSION);)
	$(foreach version, $(GOVERSION), docker tag gcloud-golang-$(version)-base $(DUSER)/gcloud-golang-$(version)-base:$(VERSION);)
	$(foreach version, $(GOVERSION), docker tag nats-golang-$(version)-base $(DUSER)/nats-golang-$(version)-base:$(VERSION);)
	$(foreach version, $(GOVERSION), docker tag kafka-golang-$(version)-base $(DUSER)/kafka-golang-$(version)-base:$(VERSION);)
	$(foreach version, $(GOVERSION), docker tag redis-golang-$(version)-base $(DUSER)/redis-golang-$(version)-base:$(VERSION);)
	$(foreach version, $(GOVERSION), docker tag nats-streaming-golang-$(version)-base $(DUSER)/nats-streaming-golang-$(version)-base:$(VERSION);)
	$(foreach component, $(COMPONENTS), docker tag google-$(component)-base $(DUSER)/google-$(component)-base:$(VERSION);)
	for version in $(GOVERSION); do for component in $(COMPONENTS); do docker tag gcloud-golang-$$version-$$component-base $(DUSER)/gcloud-golang-$$version-$$component-base:$(VERSION); done done

push:
	docker push $(DUSER)/nats-base:$(VERSION)
	docker push $(DUSER)/kafka-base:$(VERSION)
	docker push $(DUSER)/redis-base:$(VERSION)
	docker push $(DUSER)/alpine-base:$(VERSION)
	docker push $(DUSER)/google-cloud-base:$(VERSION)
	docker push $(DUSER)/google-pubsub-base:$(VERSION)
	docker push $(DUSER)/nats-streaming-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/golang-$(version)-base;)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/nats-golang-$(version)-base;)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/kafka-golang-$(version)-base;)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/redis-golang-$(version)-base;)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/gcloud-golang-$(version)-base;)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/nats-streaming-golang-$(version)-base;)
	$(foreach component, $(COMPONENTS), docker push $(DUSER)/google-$(component)-base:$(VERSION);)
	for version in $(GOVERSION); do for component in $(COMPONENTS); do docker push $(DUSER)/gcloud-golang-$$version-$$component-base:$(VERSION); done done
