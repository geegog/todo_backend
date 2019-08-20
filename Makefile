build:
    @docker build \
        -t geegog/docker-phoenix .

push:
    @docker push geegog/docker-phoenix

dev:
   @docker-compose down && \
     docker-compose build --pull --no-cache && \
     docker-compose \
       -f docker-compose.yml \
     up -d --remove-orphans

bp: build push