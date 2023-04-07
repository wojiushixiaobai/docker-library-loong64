# Docker build
```sh
chmod +x docker-entrypoint.sh
docker build -t redis:6.2 .
```

# Docker buildx build
```sh
chmod +x docker-entrypoint.sh
docker buildx build -t redis:6.2 . --load
```
