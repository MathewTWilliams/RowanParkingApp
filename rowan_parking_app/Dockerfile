FROM alpine:3.14

WORKDIR /build

ADD go/ .

RUN apk update; \
	apk add go; \
	go build .; \
	mkdir /var/www; \
	cp backend /var/www/backend;

WORKDIR /var/www
ENTRYPOINT ./backend
