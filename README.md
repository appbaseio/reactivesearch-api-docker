# Arc: Dockerize Setup

This setup enables you to run [Arc](https://arc-site.netlify.com/) with single command, i.e. `docker-compose up -d` 😎.

Dockerize setup for Arc comes with 3 different services

#### Arc

Allows you to access all [Appbase.io](https://docs.appbase.io/docs/gettingstarted/WhyAppbase/) features like search preview, actionable analytics and granular security with any ElasticSearch cluster hosted anywhere.

> **Note:** Make sure your arc container have complete access to ElasticSearch. You can use ElasticSearch URL with Basic Auth in configuring dashboard or IP restricted ElasticSearch URL where IP of your ARC cluster hosted using docker setup is white listed.

#### Configure

This service comes with simple user interface which allows you to set credentials and other environment variables, that are required by the above service.

#### Watcher

This services keeps eye on the environment file and restarts the arc service, whenever configurations are changed.

## Quick Start 🚀

The steps described here assumes a [docker](https://docs.docker.com/install/) installation on the system.

- **Step 1:** Get Arc ID following the steps mentioned [here](https://docs.appbase.io/docs/hosting/BYOC/#using-ami)

- **Step 2:** Clone the repository

  ```bash
  git clone https://github.com/appbaseio/arc-dockerized.git && cd arc-dockerized
  ```

- **Step 3:** Build and run docker containers

  We highly recommend using Arc with [SSL](https://en.wikipedia.org/wiki/Transport_Layer_Security) so that we can easily bind this with Arc Dashboard. To simplify the process of docker build and deployment we have created 3 versions:

  1 - Install Arc _(If you have your own Nginx / SSL setup)_

  ```bash
  docker-compose up -d
  ```

  2 - Install Arc + Nginx with SSL setup _(Recommended for production)_

  - Change [SSL](https://en.wikipedia.org/wiki/Transport_Layer_Security) certificate and keys with production files. Please obtain [SSL](https://en.wikipedia.org/wiki/Transport_Layer_Security) certificate and key for your domain using [Let's Encrypt](https://letsencrypt.org/) or any other provider. Update the files in [nginx/certs](https://github.com/appbaseio/arc-dockerized/tree/master/nginx/certs)
  - In case you are using different name then mentioned in [nginx/certs](https://github.com/appbaseio/arc-dockerized/tree/master/nginx/certs) folder, then please update them in `docker-compose-with-tls.yaml` file as well

  ![](https://i.imgur.com/piUKTLl.png)

  Also, make sure you update file names in [nginx/default.conf](https://github.com/appbaseio/arc-dockerized/blob/master/nginx/default.conf) file

  ![](https://i.imgur.com/LW8zOyB.png)

  ```bash
  docker-compose -f docker-compose-with-tls.yaml up -d
  ```

  3 - Install Arc + ElasticSearch _(If you want to deploy Arc Along with ElasticSearch)_

  ```
  docker-compose -f docker-compose-with-elasticsearch.yaml up -d
  ```

  🔥 Thats all, our containers should be up and running. Next let us configure environment variables required by Arc service.

- **Step 4:** Open configuration service URL in your browser, i.e. [http://localhost_OR_cluster_url:8080](http://localhost/CLUStER_URL:8080)

  > **Note:** If you are running this setup on an virtual machine, make sure port `8080` is set in your inbound rules for the cluster.

- **Step 5:** Set credentials

- **Step 6:** Configure ElasticSearch URL and ARC ID obtained above.

  > **NOte:** Once you save the configuration, it may take 5-10s to restart the arc service.

- **Step 7:** Start using Arc Services using [Arc Dashboard](https://arc-dashboard.appbase.io/). Here you will have to input Arc Cluster URL which will be [http(s)://localhost_OR_cluster_url(:8000)](<http(s)://localhost_OR_cluster_url(:8000)>) and credentials would be the one that you configured initially on _Step 5_.

  > **Note:** Arc service is exposed via port `8000` so make sure port `8000` is set in your inbound rules for the cluster.
