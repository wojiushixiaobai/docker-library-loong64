# Docker build
```sh
chmod +x docker-entrypoint.sh
docker build -t node:18.14 .
```

# Docker buildx build
```sh
chmod +x docker-entrypoint.sh
docker buildx build -t node:18.14 . --load
```
