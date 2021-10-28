FROM golang:1.16-alpine
WORKDIR /build
ADD go/ .
RUN go build .;

FROM alpine:3.14
WORKDIR /var/www
COPY --from=0 /build/backend .
ENTRYPOINT ./backend
