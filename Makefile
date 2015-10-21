all: build

build:
	@docker build --tag=quay.io/galexrt/zulip-postgresql-tsearchextras .

release: build
	@docker build --tag=quay.io/galexrt/zulip-postgresql-tsearchextras:$(shell cat VERSION) .
