all: build

build:
	docker build --tag=puja/zulip-postgresql-tsearchextras .

release: build
	docker push --tag=puja/zulip-postgresql-tsearchextras:$(shell cat VERSION) .
