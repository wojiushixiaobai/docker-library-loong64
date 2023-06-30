# Docker build
```sh
chmod +x mvn-entrypoint.sh
docker build -t maven:3.9.2-openjdk-11-slim .
```

# Docker buildx build
```sh
chmod +x mvn-entrypoint.sh
docker buildx build -t maven:3.9.2-openjdk-11-slim . --load
```