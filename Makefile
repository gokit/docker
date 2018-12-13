VERSION ?= 0.1
DUSER ?= influx6
BASE ?= alpine
DIR ?= alpine
COMPONENTS ?= app-engine-go cbt bigtable datalab cloud-datastore-emulator gcd-emulator cloud-firestore-emulator pubsub-emulator cloud_sql_proxy emulator-reverse-proxy cloud-build-local docker-credential-gcr kubectl
GOVERSION ?= 1.11.2 1.11.1 1.11 1.10 1.9 1.8 1.7
FROM_NAME='#FROM'

define COMPONENT_DOCKER_FORMAT
FROM #FROM\nARG component\nRUN set -xe && gcloud components install $$component && gcloud components update\n
endef

build: build-base build-golang build-gcloud build-redis build-kafka build-mongodb build-mariadb build-nodejs build-nats build-nats-streaming build-postgres

build-base:
	docker build -t $(base)-base -f $(DIR)/Dockerfile-base .
	docker tag $(base)-base $(DUSER)/$(base)-base:$(VERSION)
	docker push $(DUSER)/$(base)-base:$(VERSION)

build-golang: 
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t golang-$(version)-$(base)-base -f $(DIR)/Dockerfile-golang-$(base)-base .;)
	$(foreach version, $(GOVERSION), docker tag golang-$(version)-$(base)-base $(DUSER)/golang-$(version)-$(base)-base:$(VERSION);)
	# push
	$(foreach version, $(GOVERSION), docker push $(DUSER)/golang-$(version)-$(base)-base;)

build-postgres:
	# postgre
	docker build -t postgresql-$(base)-base -f $(DIR)/Dockerfile-postgresql .
	docker tag postgresql-$(base)-base $(DUSER)/postgresql-$(base)-base:$(VERSION)
	# golang postgre
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t postgresql-golang-$(version)-$(base)-base -f $(DIR)/Dockerfile-postgresql-go .;)
	$(foreach version, $(GOVERSION), docker tag postgresql-golang-$(version)-$(base)-base $(DUSER)/postgresql-golang-$(version)-$(base)-base:$(VERSION);)
	# push
	docker push $(DUSER)/postgresql-$(base)-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/postgresql-golang-$(version)-$(base)-base;)

build-nodejs:
	# nodejs
	docker build -t nodejs-$(base)-base -f $(DIR)/Dockerfile-nodejs .
	docker tag nodejs-$(base)-base $(DUSER)/nodejs-$(base)-base:$(VERSION)
	# golang nodejs
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t nodejs-golang-$(version)-$(base)-base -f $(DIR)/Dockerfile-nodejs-go .;)
	$(foreach version, $(GOVERSION), docker tag nodejs-golang-$(version)-$(base)-base $(DUSER)/nodejs-golang-$(version)-$(base)-base:$(VERSION);)
	# push
	docker push $(DUSER)/nodejs-$(base)-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/nodejs-golang-$(version)-$(base)-base;)

build-mongodb:
	# mongodb
	docker build -t mongodb-$(base)-base -f $(DIR)/Dockerfile-mongodb .
	docker tag mongodb-$(base)-base $(DUSER)/mongodb-$(base)-base:$(VERSION)
	# golang mongodb
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t mongodb-golang-$(version)-$(base)-base -f $(DIR)/Dockerfile-mongodb-go .;)
	$(foreach version, $(GOVERSION), docker tag mongodb-golang-$(version)-$(base)-base $(DUSER)/mongodb-golang-$(version)-$(base)-base:$(VERSION);)
	# push
	docker push $(DUSER)/mongodb-$(base)-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/mongodb-golang-$(version)-$(base)-base;)

build-mariadb:
	# mariadb
	docker build -t mariadb-$(base)-base -f $(DIR)/Dockerfile-mariadb .
	docker tag mariadb-$(base)-base $(DUSER)/mariadb-$(base)-base:$(VERSION)
	# golang mariadb
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t mariadb-golang-$(version)-$(base)-base -f $(DIR)/Dockerfile-mariadb-go .;)
	$(foreach version, $(GOVERSION), docker tag mariadb-golang-$(version)-$(base)-base $(DUSER)/mariadb-golang-$(version)-$(base)-base:$(VERSION);)
	# push
	docker push $(DUSER)/mariadb-$(base)-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/mariadb-golang-$(version)-$(base)-base;)

build-redis:
	# redis
	docker build -t redis-$(base)-base -f $(DIR)/Dockerfile-redis .
	docker tag redis-$(base)-base $(DUSER)/redis-$(base)-base:$(VERSION)
	# golang redis
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t redis-golang-$(version)-$(base)-base -f $(DIR)/Dockerfile-redis-golang .;)
	$(foreach version, $(GOVERSION), docker tag redis-golang-$(version)-$(base)-base $(DUSER)/redis-golang-$(version)-$(base)-base:$(VERSION);)
	# push
	docker push $(DUSER)/redis-$(base)-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/redis-golang-$(version)-$(base)-base;)

build-kafka:
	# kafka
	docker build -t kafka-$(base)-base -f $(DIR)/Dockerfile-kafka .
	docker tag kafka-$(base)-base $(DUSER)/kafka-$(base)-base:$(VERSION)
	# golan kafka
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t kafka-golang-$(version)-$(base)-base -f $(DIR)/Dockerfile-kafka-golang .;)
	$(foreach version, $(GOVERSION), docker tag kafka-golang-$(version)-$(base)-base $(DUSER)/kafka-golang-$(version)-$(base)-base:$(VERSION);)
	# push
	docker push $(DUSER)/kafka-$(base)-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/kafka-golang-$(version)-$(base)-base;)

build-nats:
	# nats
	docker build -t nats-$(base)-base -f $(DIR)/Dockerfile-nats .
	docker tag nats-$(base)-base $(DUSER)/nats-$(base)-base:$(VERSION)
	# golang nats
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t nats-golang-$(version)-$(base)-base -f $(DIR)/Dockerfile-nats-golang .;)
	$(foreach version, $(GOVERSION), docker tag nats-golang-$(version)-$(base)-base $(DUSER)/nats-golang-$(version)-$(base)-base:$(VERSION);)
	# push
	docker push $(DUSER)/nats-$(base)-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/nats-golang-$(version)-$(base)-base;)

build-nats-streaming:
	# nats-streaming
	docker build -t nats-streaming-$(base)-base -f $(DIR)/Dockerfile-nats-streaming .
	docker tag nats-streaming-$(base)-base $(DUSER)/nats-streaming-$(base)-base:$(VERSION)
	# golang nats-streaming
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t nats-streaming-golang-$(version)-$(base)-base -f $(DIR)/Dockerfile-nats-streaming-golang .;)
	$(foreach version, $(GOVERSION), docker tag nats-streaming-golang-$(version)-$(base)-base $(DUSER)/nats-streaming-golang-$(version)-$(base)-base:$(VERSION);)
	# push
	docker push $(DUSER)/nats-streaming-$(base)-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/nats-streaming-golang-$(version)-$(base)-base;)

build-gcloud:
	# gcloud
	docker build -t google-gcloud-$(base)-base -f $(DIR)/Dockerfile-gcloud .
	docker tag google-gcloud-$(base)-base $(DUSER)/google-gcloud-$(base)-base:$(VERSION)
	# components
	$(foreach component, $(COMPONENTS), docker build --build-arg component=$(component) -t google-$(component)-$(base)-base -f $(DIR)/Dockerfile-google-components .;)
	$(foreach component, $(COMPONENTS), docker tag google-$(component)-$(base)-base $(DUSER)/google-$(component)-$(base)-base:$(VERSION);)
	# golang gcloud versions
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t gcloud-golang-$(version)-$(base)-base -f $(DIR)/Dockerfile-gcloud-golang .;)
	$(foreach version, $(GOVERSION), docker tag gcloud-golang-$(version)-$(base)-base $(DUSER)/gcloud-golang-$(version)-$(base)-base:$(VERSION);)
	# golang gcloud components versions
	for version in $(GOVERSION); do for component in $(COMPONENTS); do docker build --build-arg component=$$component -t gcloud-golang-$$version-$$component-$(base)-base -f $(DIR)/Dockerfile-gcloud-golang-$$version-components .; done done
	for version in $(GOVERSION); do for component in $(COMPONENTS); do docker tag gcloud-golang-$$version-$$component-$(base)-base $(DUSER)/gcloud-golang-$$version-$$component-$(base)-base:$(VERSION); done done
	# push
	docker push $(DUSER)/google-gcloud-$(base)-base:$(VERSION)
	$(foreach component, $(COMPONENTS), docker push $(DUSER)/google-$(component)-$(base)-base:$(VERSION);)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/gcloud-golang-$(version)-$(base)-base;)
	for version in $(GOVERSION); do for component in $(COMPONENTS); do docker push $(DUSER)/gcloud-golang-$$version-$$component-$(base)-base:$(VERSION); done done

generate-golang-component-dockerfiles:
	$(foreach version, $(GOVERSION), echo '$(subst #FROM,$(DUSER)/gcloud-golang-$(version)-$(base)-base:$(VERSION),$(COMPONENT_DOCKER_FORMAT))' > $(DIR)/Dockerfile-gcloud-golang-$(version)-components;)
