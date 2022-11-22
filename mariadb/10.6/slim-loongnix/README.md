# Docker build
```sh
chmod +x *.sh
docker build -t mariadb:10.6 .
```

# Docker buildx build
```sh
chmod +x *.sh
docker buildx build -t mariadb:10.6 . --load
```
