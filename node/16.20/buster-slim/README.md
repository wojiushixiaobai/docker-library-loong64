# Docker build
```sh
chmod +x docker-entrypoint.sh
docker build -t node:16.20 .
```

# Docker buildx build
```sh
chmod +x docker-entrypoint.sh
docker buildx build -t node:16.20 . --load
```
