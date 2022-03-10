# Appbase.io: Dockerize Setup

This setup enables you to run [ReactiveSearch API server](https://reactivesearch.io/) with single command, i.e. `docker-compose up -d` 😎.

The docker-compose setup in this repository comes with four different services:

#### reactivesearch-api

`reactivesearch-api` is an opensource image providing a declarative API to query Elasticsearch, and is required by ReactiveSearch and Searchbox UI libraries. You can check out the source code over [here](https://github.com/appbaseio/reactivesearch-api).

It is also available as a licensed image with additional features such as search relevance, query rules, UI builder, pipelines, actionable search analytics and search access control. See [pricing](https://www.appbase.io/pricing).


> **Note:** Make sure your rs-api container has complete access to Elasticsearch. You can secure Elasticsearch URL with Basic Auth or set an IP based restriction.

#### reactivesearch-config-gui

The `reactivesearch-config-gui` service comes with simple user interface that allows you to set credentials and other reactivesearch-api server related environment variables. It also watches for environment variable file changes, so that if any variable in file is changed it can restart the rs-api container.

#### nginx

This service helps in setting up reverse proxy for Arc Service and serving Configuration service. It also helps in serving data using with TLS certificate, which is recommended for production.

#### elasticsearch

The Elasticsearch service allows spinning up an Elasticsearch server instance locally. This is optional, however running this service allows for an end-to-end ReactiveSearch service setup.

To run specific services only, use the following command:

`docker-compose -f ${file} up -d`

where ${file} can be one of the following:

| file                                                     | Use Case                                                                                                                                                       |
|----------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| docker-compose-oss-with-elasticsearch-without-nginx.yaml | Run the open-source ReactiveSearch API server with Elasticsearch, but without Nginx and ReactiveSearch's config GUI.                                           |
| docker-compose-oss-with-elasticsearch.yaml               | Run the open-source ReactiveSearch API server with Elasticsearch, Nginx and ReactiveSearch's config GUI.                                                       |
| docker-compose-oss.yaml                                  | Run the open-source ReactiveSearch API server with Nginx and ReactiveSearch's config GUI, but without Elasticsearch (i.e. it's assumed to be hosted in cloud). |
| docker-compose-with-elasticsearch-without-nginx.yaml     | Run the licensed ReactiveSearch API server with Elasticsearch, but without Nginx and ReactiveSearch's config GUI.                                              |
| docker-compose-with-elasticsearch.yaml                   | Run the licensed ReactiveSearch API server with Elasticsearch, Nginx and ReactiveSearch's config GUI.                                                          |
| docker-compose.yaml                                      | Run the licensed ReactiveSearch API server with Nginx and ReactiveSearch's config GUI, but without Elasticsearch (i.e. it's assumed to be hosted in cloud).    |

## Quick Start 🚀

The steps described here assumes a [docker](https://docs.docker.com/install/) installation on the system.

> Note: If you have used arc-docker setup earlier, you might need to clear `www` volume to get fresh copy of arc configuration page. Please remove containers associated with `www` volume `docker container rm ContainerID` and then run `docker volume rm www`

- **Step 1:** Get Arc ID following the steps mentioned [here](https://docs.appbase.io/docs/hosting/BYOC/#using-ami)

- **Step 2:** Clone the repository

  ```bash
  git clone https://github.com/appbaseio/arc-dockerized.git && cd arc-dockerized
  ```

- **Step 3:** Configure logging system

  Arc internally uses [Fluentbit](https://fluentbit.io/) to log the requests and provide analytics on top of that. In order to setup fluentbit, update `fluent-bit.conf` with Elasticsearch `Host`, `Port`, `tls`, `HTTP_User` and `HTTP_Passwd` information.

  ![](https://www.dropbox.com/s/ucaj3gtdj331j9v/Screenshot%202020-07-01%2011.49.34.png?raw=1)

  > **Note:** If you are using `docker-compose-with-elasticsearch.yaml` then you don't need to change any configurations in

* **Step 4:** Build and run docker containers

  We highly recommend using Arc with [SSL](https://en.wikipedia.org/wiki/Transport_Layer_Security) so that we can easily bind this with Arc Dashboard. To simplify the process of docker build, test and deployment we have created 2 versions:

  1 - **Install Arc + Nginx with SSL setup _(Recommended for production)_**

  - Change [SSL](https://en.wikipedia.org/wiki/Transport_Layer_Security) certificate and keys with production files. Please obtain [SSL](https://en.wikipedia.org/wiki/Transport_Layer_Security) certificate and key for your domain using [Let's Encrypt](https://letsencrypt.org/) or any other provider. Update the files in [nginx/certs](https://github.com/appbaseio/arc-dockerized/tree/master/nginx/certs)
  - In case you are using different name then mentioned in [nginx/certs](https://github.com/appbaseio/arc-dockerized/tree/master/nginx/certs) folder, then please update them in `docker-compose.yaml` file as well

  ![](https://i.imgur.com/piUKTLl.png)

  Also, make sure you update file names in [nginx/default.conf](https://github.com/appbaseio/arc-dockerized/blob/master/nginx/default.conf) file

  ![](https://i.imgur.com/LW8zOyB.png)

  ```bash
  docker-compose up -d
  ```

  2 - **Install Arc + Elasticsearch _(If you want to deploy Arc Along with Elasticsearch.)_**

  ```
  docker-compose -f docker-compose-with-elasticsearch.yaml up -d
  ```

  🔥 Thats all, our containers should be up and running. Next let us configure environment variables required by Arc service.

* **Step 5:** Open configuration service URL in your browser, i.e. [http://localhost](http://localhost)

  > **Note:** If you are running this setup on an virtual machine, make sure ports `80` and `443` are set in your inbound rules for the cluster.

* **Step 6:** Set credentials

* **Step 7:** Configure Elasticsearch URL and ARC ID obtained above.

  > **Note:** Once you save the configuration, it may take 5-10s to restart the arc service.

* **Step 8:** Start using Arc Services using [Arc Dashboard](https://arc-dashboard.appbase.io/). Here you will have to input Arc Cluster URL which will be [http://localhost](http://localhost) and credentials would be the one that you configured initially on **Step 5**.

## Configuring TLS for development

We recommend configuring TLS using the excellent [`mkcert`](https://github.com/FiloSottile/mkcert) utility. Once installed on your local system:

```bash
mkcert -key-file=nginx/certs/server.key -cert-file=nginx/certs/server.crt appbase.dev localhost
```

This will save the cert key and pem files into paths that are used by the nginx service in the `docker-compose-with-elasticsearch.yaml` file.

Once the certs are configured, start the service with:

```bash
docker-compose -f docker-compose-with-elasticsearch.yaml up -d
```

You can now visit: https://localhost to get a TLS domain. For https://appbase.dev to point to appbase.io service, add the entry:

```
127.0.0.1    appbase.dev
```

in your `/etc/hosts` file.