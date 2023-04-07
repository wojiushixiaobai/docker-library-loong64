# Docker build
```sh
chmod +x *.sh
docker build -t nginx:1.22 .
```

# Docker buildx build
```sh
chmod +x *.sh
docker buildx build -t nginx:1.22 . --load
```
