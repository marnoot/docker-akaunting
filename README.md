# docker-akaunting
This is an image for self-hosting Akaunting. The image includes Apache and PHP 7.3.

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
