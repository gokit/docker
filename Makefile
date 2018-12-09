VERSION ?= 0.1
DUSER ?= influx6
COMPONENTS ?= app-engine-go cbt bigtable datalab cloud-datastore-emulator gcd-emulator cloud-firestore-emulator pubsub-emulator cloud_sql_proxy emulator-reverse-proxy cloud-build-local docker-credential-gcr kubectl
GOVERSION ?= 1.11.2 1.11.1 1.11 1.10 1.9 1.8 1.7
FROM_NAME='#FROM'

define COMPONENT_DOCKER_FORMAT
FROM #FROM\nARG component\nRUN set -xe && gcloud components install $$component && gcloud components update\n
endef

default: build push

build: build-base build-golang build-gcloud build-redis build-kafka build-mongodb build-mariadb build-nodejs build-nats build-nats-streaming build-postgres

build-base:
	docker build -t alpine-base -f Dockerfile-base .
	docker tag alpine-base $(DUSER)/alpine-base:$(VERSION)
	docker push $(DUSER)/alpine-base:$(VERSION)

build-golang: 
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t golang-$(version)-base -f Dockerfile-golang-base .;)
	$(foreach version, $(GOVERSION), docker tag golang-$(version)-base $(DUSER)/golang-$(version)-base:$(VERSION);)
	# push
	$(foreach version, $(GOVERSION), docker push $(DUSER)/golang-$(version)-base;)

build-postgres:
	# postgre
	docker build -t postgresql-base -f Dockerfile-postgresql .
	docker tag postgresql-base $(DUSER)/postgresql-base:$(VERSION)
	# golang postgre
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t postgresql-golang-$(version)-base -f Dockerfile-postgresql-go .;)
	$(foreach version, $(GOVERSION), docker tag postgresql-golang-$(version)-base $(DUSER)/postgresql-golang-$(version)-base:$(VERSION);)
	# push
	docker push $(DUSER)/postgresql-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/postgresql-golang-$(version)-base;)

build-nodejs:
	# nodejs
	docker build -t nodejs-base -f Dockerfile-nodejs .
	docker tag nodejs-base $(DUSER)/nodejs-base:$(VERSION)
	# golang nodejs
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t nodejs-golang-$(version)-base -f Dockerfile-nodejs-go .;)
	$(foreach version, $(GOVERSION), docker tag nodejs-golang-$(version)-base $(DUSER)/nodejs-golang-$(version)-base:$(VERSION);)
	# push
	docker push $(DUSER)/nodejs-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/nodejs-golang-$(version)-base;)

build-mongodb:
	# mongodb
	docker build -t mongodb-base -f Dockerfile-mongodb .
	docker tag mongodb-base $(DUSER)/mongodb-base:$(VERSION)
	# golang mongodb
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t mongodb-golang-$(version)-base -f Dockerfile-mongodb-go .;)
	$(foreach version, $(GOVERSION), docker tag mongodb-golang-$(version)-base $(DUSER)/mongodb-golang-$(version)-base:$(VERSION);)
	# push
	docker push $(DUSER)/mongodb-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/mongodb-golang-$(version)-base;)

build-mariadb:
	# mariadb
	docker build -t mariadb-base -f Dockerfile-mariadb .
	docker tag mariadb-base $(DUSER)/mariadb-base:$(VERSION)
	# golang mariadb
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t mariadb-golang-$(version)-base -f Dockerfile-mariadb-go .;)
	$(foreach version, $(GOVERSION), docker tag mariadb-golang-$(version)-base $(DUSER)/mariadb-golang-$(version)-base:$(VERSION);)
	# push
	docker push $(DUSER)/mariadb-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/mariadb-golang-$(version)-base;)

build-redis:
	# redis
	docker build -t redis-base -f Dockerfile-redis .
	docker tag redis-base $(DUSER)/redis-base:$(VERSION)
	# golang redis
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t redis-golang-$(version)-base -f Dockerfile-redis-golang .;)
	$(foreach version, $(GOVERSION), docker tag redis-golang-$(version)-base $(DUSER)/redis-golang-$(version)-base:$(VERSION);)
	# push
	docker push $(DUSER)/redis-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/redis-golang-$(version)-base;)

build-kafka:
	# kafka
	docker build -t kafka-base -f Dockerfile-kafka .
	docker tag kafka-base $(DUSER)/kafka-base:$(VERSION)
	# golan kafka
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t kafka-golang-$(version)-base -f Dockerfile-kafka-golang .;)
	$(foreach version, $(GOVERSION), docker tag kafka-golang-$(version)-base $(DUSER)/kafka-golang-$(version)-base:$(VERSION);)
	# push
	docker push $(DUSER)/kafka-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/kafka-golang-$(version)-base;)

build-nats:
	# nats
	docker build -t nats-base -f Dockerfile-nats .
	docker tag nats-base $(DUSER)/nats-base:$(VERSION)
	# golang nats
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t nats-golang-$(version)-base -f Dockerfile-nats-golang .;)
	$(foreach version, $(GOVERSION), docker tag nats-golang-$(version)-base $(DUSER)/nats-golang-$(version)-base:$(VERSION);)
	# push
	docker push $(DUSER)/nats-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/nats-golang-$(version)-base;)

build-nats-streaming:
	# nats-streaming
	docker build -t nats-streaming-base -f Dockerfile-nats-streaming .
	docker tag nats-streaming-base $(DUSER)/nats-streaming-base:$(VERSION)
	# golang nats-streaming
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t nats-streaming-golang-$(version)-base -f Dockerfile-nats-streaming-golang .;)
	$(foreach version, $(GOVERSION), docker tag nats-streaming-golang-$(version)-base $(DUSER)/nats-streaming-golang-$(version)-base:$(VERSION);)
	# push
	docker push $(DUSER)/nats-streaming-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/nats-streaming-golang-$(version)-base;)

build-gcloud:
	# gcloud
	docker build -t google-gcloud-base -f Dockerfile-gcloud .
	docker tag google-gcloud-base $(DUSER)/google-gcloud-base:$(VERSION)
	# components
	$(foreach component, $(COMPONENTS), docker build --build-arg component=$(component) -t google-$(component)-base -f Dockerfile-google-components .;)
	$(foreach component, $(COMPONENTS), docker tag google-$(component)-base $(DUSER)/google-$(component)-base:$(VERSION);)
	# golang gcloud versions
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t gcloud-golang-$(version)-base -f Dockerfile-gcloud-golang .;)
	$(foreach version, $(GOVERSION), docker tag gcloud-golang-$(version)-base $(DUSER)/gcloud-golang-$(version)-base:$(VERSION);)
	# golang gcloud components versions
	for version in $(GOVERSION); do for component in $(COMPONENTS); do docker build --build-arg component=$$component -t gcloud-golang-$$version-$$component-base -f Dockerfile-gcloud-golang-$$version-components .; done done
	for version in $(GOVERSION); do for component in $(COMPONENTS); do docker tag gcloud-golang-$$version-$$component-base $(DUSER)/gcloud-golang-$$version-$$component-base:$(VERSION); done done
	# push
	docker push $(DUSER)/google-gcloud-base:$(VERSION)
	$(foreach component, $(COMPONENTS), docker push $(DUSER)/google-$(component)-base:$(VERSION);)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/gcloud-golang-$(version)-base;)
	for version in $(GOVERSION); do for component in $(COMPONENTS); do docker push $(DUSER)/gcloud-golang-$$version-$$component-base:$(VERSION); done done

generate-golang-component-dockerfiles:
	$(foreach version, $(GOVERSION), echo '$(subst #FROM,$(DUSER)/gcloud-golang-$(version)-base:$(VERSION),$(COMPONENT_DOCKER_FORMAT))' > Dockerfile-gcloud-golang-$(version)-components;)
