# Base PHP

## Techstack

- Debian 11/Bullseye
- PHP 8.0/8.1
- NodeJS 14
- Python 2.7
- PHP Opcache
- Supervisor
- Chrome Plugin for Browser testing
- Others see Dockerfile

## Docker build commands

```
docker build -t jsdecena/basephp:latest .
docker build -t jsdecena/basephp:8.1.0 .
docker build -t jsdecena/basephp:8.0.13 .
```

## Push to docker hub

```
docker login -u <username> -p <token>
docker push jsdecena/php8-fpm:<tag>
```
