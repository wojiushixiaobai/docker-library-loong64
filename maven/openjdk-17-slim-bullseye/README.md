# Docker build
```sh
chmod +x mvn-entrypoint.sh
docker build -t maven:3.9.3-openjdk-17-slim .
```

# Docker buildx build
```sh
chmod +x mvn-entrypoint.sh
docker buildx build -t maven:3.9.3-openjdk-17-slim . --load
```
