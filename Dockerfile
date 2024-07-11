FROM --platform=${TARGETPLATFORM:-linux/amd64} alpine:3.20 AS build
RUN apk add --no-cache \
    multirun \
    crystal \
    shards

RUN mkdir /app
WORKDIR /app
COPY . /app/
RUN shards build --release --static
RUN strip bin/caddywatch

FROM --platform=${TARGETPLATFORM:-linux/amd64} alpine:3.20 AS ship
RUN apk add --no-cache \
    multirun \
    caddy 

COPY --from=build /app/bin/caddywatch /usr/bin/

RUN addgroup -S app && adduser app -S -G app
WORKDIR /home/app
USER app

CMD ["/usr/bin/multirun", "-v", "caddywatch", "caddy run --config /srv/Caddyfile"]
