# Arc: Dockerize Setup

This setup enables you to run [Arc](https://arc-site.netlify.com/) with single command, i.e. `docker-compose up -d` 😎.

Dockerize setup for Arc comes with 3 different services

#### Arc

Allows you to access all [Appbase.io](https://docs.appbase.io/docs/gettingstarted/WhyAppbase/) features like search preview, actionable analytics and granular security with any ElasticSearch cluster hosted anywhere.

> **Note:** Make sure your arc container have complete access to ElasticSearch. You can use ElasticSearch URL with Basic Auth in configuring dashboard or IP restricted ElasticSearch URL where IP of your ARC cluster hosted using docker setup is white listed.

#### Configure

This service comes with simple user interface which allows you to set credentials and other environment variables. Also it watches for environment variable file changes, so that if any variable in file is changed it can restart arc service.

#### Nginx

This service helps in setting up reverse proxy for Arc Service and serving Configuration service. It also helps in serving data using with TLS certificate, which is recommended for production.

## Quick Start 🚀

The steps described here assumes a [docker](https://docs.docker.com/install/) installation on the system.

- **Step 1:** Get Arc ID following the steps mentioned [here](https://docs.appbase.io/docs/hosting/BYOC/#using-ami)

- **Step 2:** Clone the repository

  ```bash
  git clone https://github.com/appbaseio/arc-dockerized.git && cd arc-dockerized
  ```

- **Step 3:** Configure logging system

  Arc internally uses [Fluentbit](https://fluentbit.io/) to log the requests and provide analytics on top of that. In order to setup fluentbit, update `fluent-bit.conf` with ElasticSearch `Host`, `Port`, `tls`, `HTTP_User` and `HTTP_Passwd` information.

- **Step 4:** Build and run docker containers

  We highly recommend using Arc with [SSL](https://en.wikipedia.org/wiki/Transport_Layer_Security) so that we can easily bind this with Arc Dashboard. To simplify the process of docker build, test and deployment we have created 2 versions:

  ![](https://www.dropbox.com/s/ucaj3gtdj331j9v/Screenshot%202020-07-01%2011.49.34.png?raw=1)

  > **Note:** If you are using `docker-compose-with-elasticsearch.yaml` then you don't need to change any configurations in

  1 - **Install Arc + Nginx with SSL setup _(Recommended for production)_**

  - Change [SSL](https://en.wikipedia.org/wiki/Transport_Layer_Security) certificate and keys with production files. Please obtain [SSL](https://en.wikipedia.org/wiki/Transport_Layer_Security) certificate and key for your domain using [Let's Encrypt](https://letsencrypt.org/) or any other provider. Update the files in [nginx/certs](https://github.com/appbaseio/arc-dockerized/tree/master/nginx/certs)
  - In case you are using different name then mentioned in [nginx/certs](https://github.com/appbaseio/arc-dockerized/tree/master/nginx/certs) folder, then please update them in `docker-compose.yaml` file as well

  ![](https://i.imgur.com/piUKTLl.png)

  Also, make sure you update file names in [nginx/default.conf](https://github.com/appbaseio/arc-dockerized/blob/master/nginx/default.conf) file

  ![](https://i.imgur.com/LW8zOyB.png)

  ```bash
  docker-compose up -d
  ```

  2 - **Install Arc + ElasticSearch _(If you want to deploy Arc Along with ElasticSearch.)_**

  ```
  docker-compose -f docker-compose-with-elasticsearch.yaml up -d
  ```

  🔥 Thats all, our containers should be up and running. Next let us configure environment variables required by Arc service.

- **Step 5:** Open configuration service URL in your browser, i.e. [http://localhost_OR_cluster_url](http://localhost/CLUStER_URL)

  > **Note:** If you are running this setup on an virtual machine, make sure ports `80` and `443` are set in your inbound rules for the cluster.

- **Step 6:** Set credentials

- **Step 7:** Configure ElasticSearch URL and ARC ID obtained above.

  > **NOte:** Once you save the configuration, it may take 5-10s to restart the arc service.

- **Step 8:** Start using Arc Services using [Arc Dashboard](https://arc-dashboard.appbase.io/). Here you will have to input Arc Cluster URL which will be [http(s)://localhost_OR_cluster_url](<http(s)://localhost_OR_cluster_url>) and credentials would be the one that you configured initially on _Step 5_.
