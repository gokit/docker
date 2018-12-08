VERSION ?= 0.1

default: build tags build-pubsub

build:
	docker build -t alpine-base -f Dockerfile-base .
	docker build -t nats-base -f Dockerfile-nats .
	docker build -t nats-streaming-base -f Dockerfile-nats-streaming .
	docker build -t kafka-base -f Dockerfile-kafka .
	docker build -t redis-base -f Dockerfile-redis .
	docker build -t google-cloud-base -f Dockerfile-gcloud .

build-pubsub:
	docker build -t google-pubsub-base -f Dockerfile-google-pubsub .
	docker tag google-pubsub-base influx6/google-pubsub-base:$(VERSION)

push:
	docker push influx6/alpine-base:$(VERSION)
	docker push influx6/nats-base:$(VERSION)
	docker push influx6/kafka-base:$(VERSION)
	docker push influx6/redis-base:$(VERSION)
	docker push influx6/google-cloud-base:$(VERSION)
	docker push influx6/google-pubsub-base:$(VERSION)
	docker push influx6/nats-streaming-base:$(VERSION)

tags:
	docker tag alpine-base influx6/alpine-base:$(VERSION)
	docker tag nats-base influx6/nats-base:$(VERSION)
	docker tag nats-streaming-base influx6/nats-streaming-base:$(VERSION)
	docker tag kafka-base influx6/kafka-base:$(VERSION)
	docker tag redis-base influx6/redis-base:$(VERSION)
	docker tag google-cloud-base influx6/google-cloud-base:$(VERSION)

