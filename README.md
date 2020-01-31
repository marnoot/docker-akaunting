# docker-akaunting
This is an image for self-hosting Akaunting behind a proxy like Caddy or Nginx. The image includes Apache and PHP 7.3. MySQL must be provided separately.

Example Dockerfile:
```
# docker-compose.yml
version: '3'

services:
  mysql:
    image: mysql:5.7
    restart: always
    environment:
      MYSQL_DATABASE: akaunting
      MYSQL_USER: akauntinguser
      MYSQL_PASSWORD: akauntingpassword
    volumes:
      - ./mysql:/var/lib/mysql

 akaunting:
    restart: always
    image: marnoot/akaunting:latest
    depends_on:
      - mysql
    volumes:
      - ./akaunting/.env:/var/www/html/.env

  caddy: # reverse proxy provider
    image: abiosoft/caddy
    restart: always
    volumes:
      - ./Caddyfile:/etc/Caddyfile:ro
      - caddycerts:/root/.caddy
    ports:
      - 80:80 # needed for Let's Encrypt
      - 443:443
    environment:
      ACME_AGREE: 'true'              # agree to Let's Encrypt Subscriber Agreement
      EMAIL: 'myemail@email.com'  # CHANGE THIS! Optional, provided to Let's Encrypt

volumes:
  caddycerts:
```

Example Caddyfile:
```
# Caddyfile

https://myakaunting.mysite.com {
    tls {$EMAIL}
    gzip

    header / {
        # Enable HTTP Strict Transport Security (HSTS)
        Strict-Transport-Security "max-age=31536000;"
        # Enable cross-site filter (XSS) and tell browser to block detected attacks
        X-XSS-Protection "1; mode=block"
        # Disallow the site to be rendered within a frame (clickjacking protection)
        X-Frame-Options "DENY"
        # Prevent search engines from indexing (optional)
        X-Robots-Tag "none"
    }

    proxy / akaunting:80 {
      transparent
    }
}
```
