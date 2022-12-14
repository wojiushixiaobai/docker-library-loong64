# Docker build
```sh
chmod +x mvn-entrypoint.sh
docker build -t maven:3.8.6-openjdk-8-slim .
```

# Docker buildx build
```sh
chmod +x mvn-entrypoint.sh
docker buildx build -t maven:3.8.6-openjdk-8-slim . --load
```
