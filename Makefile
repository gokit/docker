VERSION ?= 0.1
DUSER ?= influx6
BASE ?= alpine
DIR ?= alpine
COMPONENTS ?= pubsub-emulator
GOVERSION ?= 1.11.2
FROM_NAME='#FROM'

define COMPONENT_DOCKER_FORMAT
FROM #FROM\nARG component\nRUN set -xe && gcloud components install $$component && gcloud components update\n
endef

build: build-base build-golang build-gcloud build-redis build-kafka build-mongodb build-mariadb build-nodejs build-nats build-nats-streaming build-postgres

build-base:
	docker build -t $(BASE)-base -f $(DIR)/Dockerfile-base .
	docker tag $(BASE)-base $(DUSER)/$(BASE)-base:$(VERSION)
	docker push $(DUSER)/$(BASE)-base:$(VERSION)

build-golang: 
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t golang-$(version)-$(BASE)-base -f $(DIR)/Dockerfile-golang-base .;)
	$(foreach version, $(GOVERSION), docker tag golang-$(version)-$(BASE)-base $(DUSER)/golang-$(version)-$(BASE)-base:$(VERSION);)
	# push
	$(foreach version, $(GOVERSION), docker push $(DUSER)/golang-$(version)-$(BASE)-base;)

build-postgres:
	# postgre
	docker build -t postgresql-$(BASE)-base -f $(DIR)/Dockerfile-postgresql .
	docker tag postgresql-$(BASE)-base $(DUSER)/postgresql-$(BASE)-base:$(VERSION)
	# golang postgre
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t postgresql-golang-$(version)-$(BASE)-base -f $(DIR)/Dockerfile-postgresql-go .;)
	$(foreach version, $(GOVERSION), docker tag postgresql-golang-$(version)-$(BASE)-base $(DUSER)/postgresql-golang-$(version)-$(BASE)-base:$(VERSION);)
	# push
	docker push $(DUSER)/postgresql-$(BASE)-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/postgresql-golang-$(version)-$(BASE)-base;)

build-nodejs:
	# nodejs
	docker build -t nodejs-$(BASE)-base -f $(DIR)/Dockerfile-nodejs .
	docker tag nodejs-$(BASE)-base $(DUSER)/nodejs-$(BASE)-base:$(VERSION)
	# golang nodejs
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t nodejs-golang-$(version)-$(BASE)-base -f $(DIR)/Dockerfile-nodejs-go .;)
	$(foreach version, $(GOVERSION), docker tag nodejs-golang-$(version)-$(BASE)-base $(DUSER)/nodejs-golang-$(version)-$(BASE)-base:$(VERSION);)
	# push
	docker push $(DUSER)/nodejs-$(BASE)-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/nodejs-golang-$(version)-$(BASE)-base;)

build-mongodb:
	# mongodb
	docker build -t mongodb-$(BASE)-base -f $(DIR)/Dockerfile-mongodb .
	docker tag mongodb-$(BASE)-base $(DUSER)/mongodb-$(BASE)-base:$(VERSION)
	# golang mongodb
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t mongodb-golang-$(version)-$(BASE)-base -f $(DIR)/Dockerfile-mongodb-go .;)
	$(foreach version, $(GOVERSION), docker tag mongodb-golang-$(version)-$(BASE)-base $(DUSER)/mongodb-golang-$(version)-$(BASE)-base:$(VERSION);)
	# push
	docker push $(DUSER)/mongodb-$(BASE)-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/mongodb-golang-$(version)-$(BASE)-base;)

build-mariadb:
	# mariadb
	docker build -t mariadb-$(BASE)-base -f $(DIR)/Dockerfile-mariadb .
	docker tag mariadb-$(BASE)-base $(DUSER)/mariadb-$(BASE)-base:$(VERSION)
	# golang mariadb
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t mariadb-golang-$(version)-$(BASE)-base -f $(DIR)/Dockerfile-mariadb-go .;)
	$(foreach version, $(GOVERSION), docker tag mariadb-golang-$(version)-$(BASE)-base $(DUSER)/mariadb-golang-$(version)-$(BASE)-base:$(VERSION);)
	# push
	docker push $(DUSER)/mariadb-$(BASE)-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/mariadb-golang-$(version)-$(BASE)-base;)

build-redis:
	# redis
	docker build -t redis-$(BASE)-base -f $(DIR)/Dockerfile-redis .
	docker tag redis-$(BASE)-base $(DUSER)/redis-$(BASE)-base:$(VERSION)
	# golang redis
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t redis-golang-$(version)-$(BASE)-base -f $(DIR)/Dockerfile-redis-golang .;)
	$(foreach version, $(GOVERSION), docker tag redis-golang-$(version)-$(BASE)-base $(DUSER)/redis-golang-$(version)-$(BASE)-base:$(VERSION);)
	# push
	docker push $(DUSER)/redis-$(BASE)-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/redis-golang-$(version)-$(BASE)-base;)

build-kafka:
	# kafka
	docker build -t kafka-$(BASE)-base -f $(DIR)/Dockerfile-kafka .
	docker tag kafka-$(BASE)-base $(DUSER)/kafka-$(BASE)-base:$(VERSION)
	# golan kafka
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t kafka-golang-$(version)-$(BASE)-base -f $(DIR)/Dockerfile-kafka-golang .;)
	$(foreach version, $(GOVERSION), docker tag kafka-golang-$(version)-$(BASE)-base $(DUSER)/kafka-golang-$(version)-$(BASE)-base:$(VERSION);)
	# push
	docker push $(DUSER)/kafka-$(BASE)-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/kafka-golang-$(version)-$(BASE)-base;)

build-nats:
	# nats
	docker build -t nats-$(BASE)-base -f $(DIR)/Dockerfile-nats .
	docker tag nats-$(BASE)-base $(DUSER)/nats-$(BASE)-base:$(VERSION)
	# golang nats
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t nats-golang-$(version)-$(BASE)-base -f $(DIR)/Dockerfile-nats-golang .;)
	$(foreach version, $(GOVERSION), docker tag nats-golang-$(version)-$(BASE)-base $(DUSER)/nats-golang-$(version)-$(BASE)-base:$(VERSION);)
	# push
	docker push $(DUSER)/nats-$(BASE)-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/nats-golang-$(version)-$(BASE)-base;)

build-nats-streaming:
	# nats-streaming
	docker build -t nats-streaming-$(BASE)-base -f $(DIR)/Dockerfile-nats-streaming .
	docker tag nats-streaming-$(BASE)-base $(DUSER)/nats-streaming-$(BASE)-base:$(VERSION)
	# golang nats-streaming
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t nats-streaming-golang-$(version)-$(BASE)-base -f $(DIR)/Dockerfile-nats-streaming-golang .;)
	$(foreach version, $(GOVERSION), docker tag nats-streaming-golang-$(version)-$(BASE)-base $(DUSER)/nats-streaming-golang-$(version)-$(BASE)-base:$(VERSION);)
	# push
	docker push $(DUSER)/nats-streaming-$(BASE)-base:$(VERSION)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/nats-streaming-golang-$(version)-$(BASE)-base;)

build-gcloud:
	# gcloud
	docker build -t google-gcloud-$(BASE)-base -f $(DIR)/Dockerfile-gcloud .
	docker tag google-gcloud-$(BASE)-base $(DUSER)/google-gcloud-$(BASE)-base:$(VERSION)
	# components
	$(foreach component, $(COMPONENTS), docker build --build-arg component=$(component) -t google-$(component)-$(BASE)-base -f $(DIR)/Dockerfile-google-components .;)
	$(foreach component, $(COMPONENTS), docker tag google-$(component)-$(BASE)-base $(DUSER)/google-$(component)-$(BASE)-base:$(VERSION);)
	# golang gcloud versions
	$(foreach version, $(GOVERSION), docker build --build-arg VERSION=$(version) -t gcloud-golang-$(version)-$(BASE)-base -f $(DIR)/Dockerfile-gcloud-golang .;)
	$(foreach version, $(GOVERSION), docker tag gcloud-golang-$(version)-$(BASE)-base $(DUSER)/gcloud-golang-$(version)-$(BASE)-base:$(VERSION);)
	# golang gcloud components versions
	for version in $(GOVERSION); do for component in $(COMPONENTS); do docker build --build-arg component=$$component -t gcloud-golang-$$version-$$component-$(BASE)-base -f $(DIR)/Dockerfile-gcloud-golang-$$version-components .; done done
	for version in $(GOVERSION); do for component in $(COMPONENTS); do docker tag gcloud-golang-$$version-$$component-$(BASE)-base $(DUSER)/gcloud-golang-$$version-$$component-$(BASE)-base:$(VERSION); done done
	# push
	docker push $(DUSER)/google-gcloud-$(BASE)-base:$(VERSION)
	$(foreach component, $(COMPONENTS), docker push $(DUSER)/google-$(component)-$(BASE)-base:$(VERSION);)
	$(foreach version, $(GOVERSION), docker push $(DUSER)/gcloud-golang-$(version)-$(BASE)-base;)
	for version in $(GOVERSION); do for component in $(COMPONENTS); do docker push $(DUSER)/gcloud-golang-$$version-$$component-$(BASE)-base:$(VERSION); done done

generate-golang-component-dockerfiles:
	$(foreach version, $(GOVERSION), echo '$(subst #FROM,$(DUSER)/gcloud-golang-$(version)-$(BASE)-base:$(VERSION),$(COMPONENT_DOCKER_FORMAT))' > $(DIR)/Dockerfile-gcloud-golang-$(version)-components;)
