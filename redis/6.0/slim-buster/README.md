# Docker build
```sh
chmod +x docker-entrypoint.sh
docker build -t redis:6.0 .
```

# Docker buildx build
```sh
chmod +x docker-entrypoint.sh
docker buildx build -t redis:6.0 . --load
```
