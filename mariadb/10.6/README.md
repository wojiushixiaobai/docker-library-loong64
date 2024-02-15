# Quick reference

-	**Where to get help**:  
	[Database Adminstrators (Stack Exchange)](https://dba.stackexchange.com/questions/tagged/docker+mariadb), [MariaDB Knowledge Base](https://mariadb.com/kb/en/docker-and-mariadb/) ([Ask a Question here](https://mariadb.com/kb/en/docker-and-mariadb/ask) available).

Also see the ["Getting Help with MariaDB" article on the MariaDB Knowledge Base](https://mariadb.com/kb/en/getting-help-with-mariadb/).

# Supported tags and respective `Dockerfile` links

-	[`10.6`](https://github.com/wojiushixiaobai/docker-library-loong64/blob/master/mariadb/10.6/slim-buster/Dockerfile)

# Quick reference (cont.)

-	**Where to file issues**:  
	Issues can be filed on [GitHub](https://github.com/wojiushixiaobai/docker-library-loong64/issues)

-	**Supported architectures**: ([more info](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
	[`amd64`](https://hub.docker.com/r/amd64/mariadb/), [`arm64v8`](https://hub.docker.com/r/arm64v8/mariadb/), ~~[`ppc64le`](https://hub.docker.com/r/ppc64le/mariadb/)~~, [`s390x`](https://hub.docker.com/r/s390x/mariadb/)

# What is MariaDB?

MariaDB Server is one of the most popular database servers in the world. It's made by the original developers of MySQL and guaranteed to stay open source. Notable users include Wikipedia, DBS Bank, and ServiceNow.

The intent is also to maintain high compatibility with MySQL, ensuring a library binary equivalency and exact matching with MySQL APIs and commands. MariaDB developers continue to develop new features and improve performance to better serve its users.

![logo](https://raw.githubusercontent.com/docker-library/docs/554e4b9aaac2e266b9ab31e9a312cb6f96d69286/mariadb/logo.png)

# How to use this image

## Start a `mariadb` server instance

Starting a MariaDB instance with the latest version is simple:

```console
$ docker run --detach --name some-mariadb --env MARIADB_USER=example-user --env MARIADB_PASSWORD=my_cool_secret --env MARIADB_ROOT_PASSWORD=my-secret-pw jumpserver/mariadb:latest
```

or:

```console
$ docker network create some-network 
$ docker run --detach --network some-network --name some-mariadb --env MARIADB_USER=example-user --env MARIADB_PASSWORD=my_cool_secret --env MARIADB_ROOT_PASSWORD=my-secret-pw jumpserver/mariadb:latest
```

... where `some-network` is a newly created network (other than `bridge` as the default network), `some-mariadb` is the name you want to assign to your container, `my-secret-pw` is the password to be set for the MariaDB root user. See the list above for relevant tags to match your needs and environment.

## Connect to MariaDB from the MySQL/MariaDB command line client

The following command starts another `mariadb` container instance and runs the `mariadb` command line client against your original `mariadb` container, allowing you to execute SQL statements against your database instance:

```console
$ docker run -it --network some-network --rm mariadb mariadb -hsome-mariadb -uexample-user -p
```

... where `some-mariadb` is the name of your original `mariadb` container (connected to the `some-network` Docker network).

This image can also be used as a client for non-Docker or remote instances:

```console
$ docker run -it --rm mariadb mariadb -h <server container IP> -u example-user -p
```

That will give you a standard MariaDB prompt. You can test it with:

```console
MariaDB [(none)]> SELECT VERSION();
```

... which should give you the version. You can then use `exit` to leave the MariaDB command line client and the client container.

More information about the MariaDB command-line client can be found in the [MariaDB Knowledge Base](https://mariadb.com/kb/en/mysql-command-line-client/)

## ... via [`docker-compose`](https://github.com/docker/compose) or [`docker stack deploy`](https://docs.docker.com/engine/reference/commandline/stack_deploy/)

Example `docker-compose.yml` for `mariadb`:

```yaml
# Use root/example as user/password credentials
version: '3.1'

services:

  db:
    image: mariadb
    restart: always
    environment:
      MARIADB_ROOT_PASSWORD: example

  adminer:
    image: adminer
    restart: always
    ports:
      - 8080:8080
```

[![Try in PWD](https://github.com/play-with-docker/stacks/raw/cff22438cb4195ace27f9b15784bbb497047afa7/assets/images/button.png)](http://play-with-docker.com?stack=https://raw.githubusercontent.com/docker-library/docs/cf3a7fba4dfd134e3f7f5921b580c71e0fd8bc24/mariadb/stack.yml)

Run `docker stack deploy -c stack.yml mariadb` (or `docker-compose -f stack.yml up`), wait for it to initialize completely, and visit `http://swarm-ip:8080`, `http://localhost:8080`, or `http://host-ip:8080` (as appropriate).

## Container shell access and viewing MariaDB logs

The `docker exec` command allows you to run commands inside a Docker container. The following command line will give you a bash shell inside your `mariadb` container:

```console
$ docker exec -it some-mariadb bash
```

The log is available through Docker's container log:

```console
$ docker logs some-mariadb
```

## Using a custom MariaDB configuration file

Custom configuration files should end in `.cnf` and be mounted at the directory `/etc/mysql/conf.d`. These files should contain the minimal changes from the MariaDB workload required for your application/environment. A MariaDB configuration file will have a `[mariadb]` group followed by `variable` = `value` settings per [Setting Server System Variables](https://mariadb.com/kb/en/server-system-variables/#setting-server-system-variables) or [option-prefix-variable](https://mariadb.com/kb/en/configuring-mariadb-with-option-files/#option-prefixes).

The `mariadb` image configuration contains the Ubuntu MariaDB variables with two custom changes for the container:

	[host-cache-size=0](https://mariadb.com/kb/en/server-system-variables/#host_cache_size)
	[skip-name-resolve](https://mariadb.com/kb/en/server-system-variables/#skip_name_resolve)

These disable the authentication of `user@hostname` users. To re-enable the `skip-name-resolve` use `disable-skip-name-resolve` as variable or arguement. When enabled, the `host-cache-size` should be sufficient for the number of containers connecting to the `mariadb`.

To view the resulting configuration of your `mariadb` container:

```console
$ docker run --name some-mariadb -v /my/custom:/etc/mysql/conf.d --rm jumpserver/mariadb:latest my_print_defaults --mysqld
```

### Configuration without a `cnf` file

Many configuration options can be passed as flags to `mariadbd`. This will give you the flexibility to customize the container without needing a `cnf` file. For example, if you want to run on port 3808 just run the following:

```console
$ docker run --name some-mariadb -e MARIADB_ROOT_PASSWORD=my-secret-pw -d jumpserver/mariadb:latest --port 3808
```

If you would like to see a complete list of available options, just run:

```console
$ docker run -it --rm jumpserver/mariadb:latest --verbose --help
```

## Environment Variables

When you start the `mariadb` image, you can adjust the initialization of the MariaDB instance by passing one or more environment variables on the `docker run` command line. Do note that none of the variables below will have any effect if you start the container with a data directory that already contains a database: any pre-existing database will always be left untouched on container startup.

From tag 10.2.38, 10.3.29, 10.4.19, 10.5.10 onwards, and all 10.6 and later tags, the `MARIADB_*` equivalent variables are provided. `MARIADB_*` variants will always be used in preference to `MYSQL_*` variants.

One of `MARIADB_RANDOM_ROOT_PASSWORD`, `MARIADB_ROOT_PASSWORD_HASH`, `MARIADB_ROOT_PASSWORD` or `MARIADB_ALLOW_EMPTY_ROOT_PASSWORD` (or equivalents, including `*_FILE`), is required. The other environment variables are optional.

### `MARIADB_ROOT_PASSWORD` / `MYSQL_ROOT_PASSWORD`, `MARIADB_ROOT_PASSWORD_HASH`

This specifies the password that will be set for the MariaDB `root` superuser account. In the above example, it was set to `my-secret-pw`.

In order to have no plaintext secret in the deployment, `MARIADB_ROOT_PASSWORD_HASH` can be used as it is just the hash of the password. The hash can be generated with `SELECT PASSWORD('thepassword')` as a SQL query.

### `MARIADB_ALLOW_EMPTY_ROOT_PASSWORD` / `MYSQL_ALLOW_EMPTY_PASSWORD`

Set to a non-empty value, like `yes`, to allow the container to be started with a blank password for the root user. *NOTE*: Setting this variable to `yes` is not recommended unless you really know what you are doing, since this will leave your MariaDB instance completely unprotected, allowing anyone to gain complete superuser access.

### `MARIADB_RANDOM_ROOT_PASSWORD` / `MYSQL_RANDOM_ROOT_PASSWORD`

Set to a non-empty value, like `yes`, to generate a random initial password for the root user. The generated root password will be printed to stdout (`GENERATED ROOT PASSWORD: .....`).

### `MARIADB_ROOT_HOST` / `MYSQL_ROOT_HOST`

This is the hostname part of the root user created. By default this is `%`, however it can be set to any default [MariaDB allowed hostname component](https://mariadb.com/kb/en/create-user/#host-name-component). Setting this to `localhost` will prevent any root user being accessible except via the unix socket.

### `MARIADB_MYSQL_LOCALHOST_USER` / `MARIADB_MYSQL_LOCALHOST_GRANTS`

Set `MARIADB_MYSQL_LOCALHOST_USER` to a non-empty value to create the `mysql@locahost` database user. This user is especially useful for a variety of health checks and backup scripts.

The `mysql@localhost` user gets [USAGE](https://mariadb.com/kb/en/grant/#the-usage-privilege) privileges by default. If more access is required, additional [global privileges](https://mariadb.com/kb/en/grant/#global-privileges) in the form of a comma separated list can be provided. If you are sharing a volume containing MariaDB's unix socket (`/var/run/mysqld` by default), privileges beyond `USAGE` can result in confidentiality, integrity and availability risks, so use a minimal set. See the example below on using Mariabackup. The `healthcheck.sh` script also documents the required privileges for each health check test.

### `MARIADB_DATABASE` / `MYSQL_DATABASE`

This variable allows you to specify the name of a database to be created on image startup.

### `MARIADB_USER` / `MYSQL_USER`, `MARIADB_PASSWORD` / `MYSQL_PASSWORD`, `MARIADB_PASSWORD_HASH`

These are used in conjunction to create a new user and to set that user's password. Both user and password variables are required for a user to be created. This user will be granted all access ([corresponding to `GRANT ALL`](https://mariadb.com/kb/en/grant/#the-all-privileges-privilege)) to the `MARIADB_DATABASE` database.

See `MARIADB_ROOT_PASSWORD_HASH` above for how to get a password hash for `MARIADB_PASSWORD_HASH`.

Do note that there is no need to use this mechanism to create the root superuser, that user gets created by default with the password specified by the `MARIADB_ROOT_PASSWORD*` variable.

### `MARIADB_INITDB_SKIP_TZINFO` / `MYSQL_INITDB_SKIP_TZINFO`

By default, the entrypoint script automatically loads the timezone data needed for the `CONVERT_TZ()` function. If it is not needed, any non-empty value disables timezone loading.

### `MARIADB_AUTO_UPGRADE` / `MARIADB_DISABLE_UPGRADE_BACKUP`

Set `MARIADB_AUTO_UPGRADE` to a non-empty value to have the entrypoint check whether `mysql_upgrade`/`mariadb-upgrade` needs to run, and if so, run the upgrade before starting the MariaDB server.

Before the upgrade, a backup of the system database is created in the top of the datadir with the name `system_mysql_backup_*.sql.zst`. This backup process can be disabled with by setting `MARIADB_DISABLE_UPGRADE_BACKUP` to a non-empty value.

## Docker Secrets

As an alternative to passing sensitive information via environment variables, `_FILE` may be appended to the previously listed environment variables, causing the initialization script to load the values for those variables from files present in the container. In particular, this can be used to load passwords from Docker secrets stored in `/run/secrets/<secret_name>` files. For example:

```console
$ docker run --name some-mysql -e MARIADB_ROOT_PASSWORD_FILE=/run/secrets/mysql-root -d jumpserver/mariadb:latest
```

Currently, this is only supported for `MARIADB_ROOT_PASSWORD`, `MARIADB_ROOT_PASSWORD_HASH`, `MARIADB_ROOT_HOST`, `MARIADB_DATABASE`, `MARIADB_USER`, `MARIADB_PASSWORD` and `MARIADB_PASSWORD_HASH` (and `MYSQL_*` equivalents of these).

# Initializing a fresh instance

When a container is started for the first time, a new database with the specified name will be created and initialized with the provided configuration variables. Furthermore, it will execute files with extensions `.sh`, `.sql`, `.sql.gz`, `.sql.xz` and `.sql.zst` that are found in `/docker-entrypoint-initdb.d`. Files will be executed in alphabetical order. `.sh` files without file execute permission are sourced rather than executed. You can easily populate your `mariadb` services by [mounting a SQL dump into that directory](https://docs.docker.com/engine/tutorials/dockervolumes/#mount-a-host-file-as-a-data-volume) and provide [custom images](https://docs.docker.com/reference/builder/) with contributed data. SQL files will be imported by default to the database specified by the `MARIADB_DATABASE` / `MYSQL_DATABASE` variable.

# Caveats

## Where to Store Data

For further information on Mariabackup, see the [Mariabackup Knowledge Base](https://mariadb.com/kb/en/mariabackup-overview/).

## How to reset root and user passwords

If you have an existing data directory and wish to reset the root and user passwords, and to create a database on which the user can fully modify, perform the following steps.

First create a `passwordreset.sql` file:

```text
CREATE USER IF NOT EXISTS root@localhost IDENTIFIED BY 'thisismyrootpassword';
SET PASSWORD FOR root@localhost = PASSWORD('thisismyrootpassword');
GRANT ALL ON *.* TO root@localhost WITH GRANT OPTION;
CREATE USER IF NOT EXISTS root@'%' IDENTIFIED BY 'thisismyrootpassword';
SET PASSWORD FOR root@'%' = PASSWORD('thisismyrootpassword');
GRANT ALL ON *.* TO root@'%' WITH GRANT OPTION;
CREATE USER IF NOT EXISTS myuser@'%' IDENTIFIED BY 'thisismyuserpassword';
SET PASSWORD FOR myuser@'%' = PASSWORD('thisismyuserpassword');
CREATE DATABASE IF NOT EXISTS databasename;
GRANT ALL ON databasename.* TO myuser@'%';
```

Adjust `myuser`, `databasename` and passwords as needed.

Then:

```console
$ docker run --rm -v /my/own/datadir:/var/lib/mysql -v /my/own/passwordreset.sql:/passwordreset.sql:z jumpserver/mariadb:latest --init-file=/passwordreset.sql
```

On restarting the MariaDB container on this `/my/own/datadir`, the `root` and `myuser` passwords will be reset.

### Creating a image with plugins from additional packages

A new image needs to be created when using additional packages. The mariadb image can be used as a base however:

In the following the [CONNECT Storage Engine](https://mariadb.com/kb/en/connect/) is installed:

```dockerfile
FROM jumpserver/mariadb:latest
RUN apt-get update && \
    apt-get install mariadb-plugin-connect -y && \
    rm -rf /var/lib/apt/lists/*
```

Installing plugins from packages creates a configuration file in the directory `/etc/mysql/mariadb.conf.d/` that loads the plugin on startup.

# License

View [license information](https://mariadb.com/kb/en/library/licensing-faq/) for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

Some additional license information which was able to be auto-detected might be found in [the `repo-info` repository's `mariadb/` directory](https://github.com/docker-library/repo-info/tree/master/repos/mariadb).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.