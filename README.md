# caddywatch

A docker image to automatically serve multiple static websites using Caddy.

## Installation and Usage

Run it using something like this docker compose file (either caddy-static-arm64 or caddy-static, depending on your architecture):

```yaml
version: "3.8"
services:
  web:
    logging:
      driver: journald
      options:
        tag: web
    container_name: web
    stdin_open: true
    tty: true
    ports:
      - 8080:8888
    volumes:
      - /data/websites/:/srv/
    image: ghcr.io/ralsina/caddy-static-arm64:latest
    restart: always
networks: {}
```

In `/srv/` you should mount a folder that has:

* A subfolder for each site you want to serve, the name of the folder
  is the domain for the site (like `/srv/ralsina.me` for `ralsina.me`)
* An **empty** file called `sites` which is writable by the user
  inside the container (just make it world-writable)
* A Caddyfile. Mine is this:


```caddy
{
        http_port 8888
        https_port 8887
        local_certs
}

import sites
```


## Development & Contributing

I don't expect anyone will use nor contribute to this, but hey:

1. Fork it (<https://github.com/your-github-user/caddy-static/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Roberto Alsina](https://github.com/ralsina) - creator and maintainer
