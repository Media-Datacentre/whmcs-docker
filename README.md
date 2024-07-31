# Dockerised WHMCS

This repository will stand up a WHMCS locally in docker, with a dockerised mariadb setup.

It should fit the following use-cases:
1. Local development, including for modules/templates and integration of other systems
2. Production deployments, with WHMCS recommended hardening considered

We can't distribute built versions of this container, as WHMCS is a proprietary product so you must build it yourself.

## Requirements

You must have docker-engine (ensure it comes with the new compose) or Docker Desktop (licensed) installed to run this.

You will need a valid developer license to run this locally, or production license to run this in a publicly facing environment.

Beware there are some finicky considerations with WHMCS around apparent IP addresses and hostnames, for which you must contact WHMCS support to resolve.

## Building

You will need to provide a zipped version of WHMCS in the `whmcs` folder. It is a proprietary product so cannot be distributed in this repository.

After this building should be as simple as

```
docker build -t whmcs-docker:latest ./whmcs
```
or
```
docker compose build
```

### Details

We use a well developed and updated base image from webdevops, this is to save on maintenance burden and developer mistakes.

You can either build your modules and templates into an image by using `WHMCS_MODULES_DOWNLOAD` during build (space separated ZIP list) or creating a base image and using it in a FROM where you add your modules/templates.


## Usage

Installer note: For the first use of WHMCS you need to use the WHMCS installer to setup the database and populate data.

You have 2 options:
1. Below, in `.env` set `WHMCS_RUN_INSTALLER` to `yes`
2. After the `up` wait for the containers to come up and run `docker exec -it -u application $WHMCS_CONTAINER_NAME php /app/install/bin/installer.php -i -n`

### Docker compose

The `docker-compose.yml` is meant to be able to stand up a self-contained developer environment from scratch.

A Docker Volume is used to store the database files.

```
cp example.env .env
docker compose build
docker compose up -d
```

#### mysql access

Executing `mysql` within the container as the `application` user will get you into the database.

```
docker exec -it -u application $WHMCS_CONTAINER_NAME /usr/bin/mysql
```

### Production

The main production considerations are

- Using secure credentials for the database (`WHMCS_DB_USERNAME` and `WHMCS_DB_PASSWORD`)
- Setting `WHMCS_CC_HASH` to something secure
- Not writing the user convenience .my.cnf (`WHMCS_WRITE_MY_CNF` to no)
- Ensuring `NGINX_SERVER_NAME` is set to your FQDN
- Using a production `WHMCS_LICENSE`
- Setting `WHMCS_ADMIN_PATH` to something obscure (`openssl rand -hex 16` is a good start)
- Not adding modules/templates during runtime with `WHMCS_MODULES_DOWNLOAD` (think about it!)
  - See building/details above
- Using some form of one-shot container task to do `WHMCS_RUN_INSTALLER` as necessary

## Issues

If you encounter an issue with the Dockerfile or scripts used to get WHMCS running, please raise an issue.

Problems with WHMCS and inherent problems with Dockerising WHMCS itself should be taken to WHMCS support for them to investigate.

