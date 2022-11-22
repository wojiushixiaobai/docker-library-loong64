# Docker build
```sh
chmod +x *.sh
docker build -t nginx:alpine .
```

# Docker buildx build
```sh
chmod +x *.sh
docker buildx build -t nginx:alpine . --load
```
