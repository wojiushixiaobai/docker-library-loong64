# Docker build
```sh
chmod +x docker-entrypoint.sh
docker build -t redis:7.2 .
```

# Docker buildx build
```sh
chmod +x docker-entrypoint.sh
docker buildx build -t redis:7.2 . --load
```
