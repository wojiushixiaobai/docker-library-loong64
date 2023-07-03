# Docker build
```sh
chmod +x docker-entrypoint.sh
docker build -t node:14.16 .
```

# Docker buildx build
```sh
chmod +x docker-entrypoint.sh
docker buildx build -t node:14.16 . --load
```
