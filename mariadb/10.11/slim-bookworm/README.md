# Docker build
```sh
chmod +x *.sh
docker build -t mariadb:10.11 .
```

# Docker buildx build
```sh
chmod +x *.sh
docker buildx build -t mariadb:10.11 . --load
```
