VERSION ?= 0.1
DUSER ?= influx6
COMPONENTS = app-engine-go cbt bigtable datalab cloud-datastore-emulator gcd-emulator cloud-firestore-emulator pubsub-emulator cloud_sql_proxy emulator-reverse-proxy cloud-build-local docker-credential-gcr kubectl

default: build tags push

build: build-bases build-components

build-base:
	docker build -t alpine-base -f Dockerfile-base .
	docker tag alpine-base $(DUSER)/alpine-base:$(VERSION)

build-components:
	$(foreach component, $(COMPONENTS), docker build --build-arg component=$(component) -t google-$(component)-base -f Dockerfile-google-components .; docker tag google-$(component)-base $(DUSER)/google-$(component)-base:$(VERSION);)

build-bases: build-base
	docker build --build-arg VERSION=1.11.2 -t golang-base-1-11-2 -f Dockerfile-golang-base .
	docker build --build-arg VERSION=1.11.1 -t golang-base-1-11-1 -f Dockerfile-golang-base .
	docker build --build-arg VERSION=1.11 -t golang-base-1-11-0 -f Dockerfile-golang-base .
	docker build --build-arg VERSION=1.10 -t golang-base-1-10-0 -f Dockerfile-golang-base .
	docker build --build-arg VERSION=1.9 -t golang-base-1-9-0 -f Dockerfile-golang-base .
	docker build --build-arg VERSION=1.8 -t golang-base-1-8-0 -f Dockerfile-golang-base .
	docker build --build-arg VERSION=1.7 -t golang-base-1-7-0 -f Dockerfile-golang-base .
	docker build -t nats-base -f Dockerfile-nats .
	docker build -t kafka-base -f Dockerfile-kafka .
	docker build -t redis-base -f Dockerfile-redis .
	docker build -t google-cloud-base -f Dockerfile-gcloud .
	docker build -t nats-streaming-base -f Dockerfile-nats-streaming .

push:
	docker push $(DUSER)/alpine-base:$(VERSION)
	docker push $(DUSER)/golang-base-1-11-2:$(VERSION)
	docker push $(DUSER)/golang-base-1-11-1:$(VERSION)
	docker push $(DUSER)/golang-base-1-11-0:$(VERSION)
	docker push $(DUSER)/golang-base-1-10-0:$(VERSION)
	docker push $(DUSER)/golang-base-1-9-0:$(VERSION)
	docker push $(DUSER)/golang-base-1-8-0:$(VERSION)
	docker push $(DUSER)/golang-base-1-7-0:$(VERSION)
	docker push $(DUSER)/nats-base:$(VERSION)
	docker push $(DUSER)/kafka-base:$(VERSION)
	docker push $(DUSER)/redis-base:$(VERSION)
	docker push $(DUSER)/google-cloud-base:$(VERSION)
	docker push $(DUSER)/google-pubsub-base:$(VERSION)
	docker push $(DUSER)/nats-streaming-base:$(VERSION)

tags:
	docker tag golang-base-1-11-2:$(VERSION) $(DUSER)/golang-base-1-11-2:$(VERSION)
	docker tag golang-base-1-11-1:$(VERSION) $(DUSER)/golang-base-1-11-1:$(VERSION)
	docker tag golang-base-1-11-0:$(VERSION) $(DUSER)/golang-base-1-11-0:$(VERSION)
	docker tag golang-base-1-10-2:$(VERSION) $(DUSER)/golang-base-1-10-0:$(VERSION)
	docker tag golang-base-1-9-0:$(VERSION) $(DUSER)/golang-base-1-9-0:$(VERSION)
	docker tag golang-base-1-8-0:$(VERSION) $(DUSER)/golang-base-1-8-0:$(VERSION)
	docker tag golang-base-1-7-0:$(VERSION) $(DUSER)/golang-base-1-7-0:$(VERSION)
	docker tag nats-base $(DUSER)/nats-base:$(VERSION)
	docker tag nats-streaming-base $(DUSER)/nats-streaming-base:$(VERSION)
	docker tag kafka-base $(DUSER)/kafka-base:$(VERSION)
	docker tag redis-base $(DUSER)/redis-base:$(VERSION)
	docker tag google-cloud-base $(DUSER)/google-cloud-base:$(VERSION)

