[![Build Status](https://travis-ci.org/actionml/docker-spark.svg?branch=master)](https://travis-ci.org/actionml/docker-spark)  [![Go to Docker Hub](https://img.shields.io/badge/Docker%20Hub-%E2%86%92-blue.svg)](https://hub.docker.com/r/actionml/spark/) [![](https://images.microbadger.com/badges/version/actionml/spark.svg)](https://microbadger.com/images/actionml/spark) [![](https://images.microbadger.com/badges/image/actionml/spark.svg)](https://microbadger.com/images/actionml/spark)

# Docker container for spark (standalone cluster)

## Starting up

This repository contains a set of scripts and configuration files to run a [Apache Spark](https://spark.apache.org/) standalone cluster from [Docker](https://www.docker.io/) container.

To start master, workers or shell (on the same docker host),  you can invoke the following commands:

```
# Spawn master
docker run -d --name spark-master actionml/spark master
master_ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' spark-master)

# Spawn workers
docker run -d --name spark-worker0 actionml/spark worker spark://$master_ip:7077
docker run -d --name spark-worker1 actionml/spark worker spark://$master_ip:7077

# Spawn shell
docker run --rm -it actionml/spark shell --master spark://$master_ip:7077
```

## Configuration

There's a set of environment variables and command line arguments which can be passed to the spark container (daemon). Containers can be started by both providing an environment variable and a command line argument, the former has higher priority. Namely, when `SPARK_MASTER_WEBUI_PORT=8080` is given and `--webui-port 8090` is passed, this will result in that master webui will start on port `8090`.

**Container managed variables**: *SPARK_MASTER_IP*, *SPARK_WORKER_IP*. This variables override spark defaults and bind services inside a container to all addresses (`0.0.0.0`).

Details about standalone configuration mode can be found in the **[documentation](http://spark.apache.org/docs/latest/spark-standalone.html#cluster-launch-scripts)**. The full list of all spark related environment variables can be also glanced at [spark-env.sh.template](https://github.com/apache/spark/blob/master/conf/spark-env.sh.template).


**Mind that** there is no need to pass `--properties-file` since the default one is already provided [spark-defaults.conf](spark-defaults.conf), if you might want to change the default values just pass `/spark-defaults.conf` volume to the container.

### Spark Master

Spark master command line usage:

```
$ docker run --rm -it actionml/docker-spark master --help
Usage: Master [options]

Options:
  -i HOST, --ip HOST     Hostname to listen on (deprecated, please use --host or -h)
  -h HOST, --host HOST   Hostname to listen on
  -p PORT, --port PORT   Port to listen on (default: 7077)
  --webui-port PORT      Port for web UI (default: 8080)
  --properties-file FILE Path to a custom Spark properties file.
                         Default is conf/spark-defaults.conf.
```

For the list of available master environment options and additional details please refer to **[documentation](http://spark.apache.org/docs/latest/spark-standalone.html#cluster-launch-scripts)!**

### Spark Worker

CLI usage:

```
$ docker run --rm -it actionml/docker-spark worker --help
Usage: Worker [options] <master>

Master must be a URL of the form spark://hostname:port

Options:
  -c CORES, --cores CORES  Number of cores to use
  -m MEM, --memory MEM     Amount of memory to use (e.g. 1000M, 2G)
  -d DIR, --work-dir DIR   Directory to run apps in (default: SPARK_HOME/work)
  -i HOST, --ip IP         Hostname to listen on (deprecated, please use --host or -h)
  -h HOST, --host HOST     Hostname to listen on
  -p PORT, --port PORT     Port to listen on (default: random)
  --webui-port PORT        Port for web UI (default: 8081)
  --properties-file FILE   Path to a custom Spark properties file.
                           Default is conf/spark-defaults.conf.
```

For the list of available worker environment options and additional details please refer to **[documentation](http://spark.apache.org/docs/latest/spark-standalone.html#cluster-launch-scripts)!**

Mind that *SPARK_WORKER_INSTANCES* is not applicable to container, if you need to start several workers you need to start several containers.

### Other

If you are planning to use spark shell, it's advised to look at [Zeppelin](https://zeppelin.incubator.apache.org/), it could be used instead of spark shell for working with data. It has pleasant GUI and IPython like functionality.

# Important notes

## Spark scratch volumes

Mind that in production use the following directories *must* be passed to spark containers as volumes.

* `SPARK_HOME/work` directory used on worker for scratch space and job output logs.
*  `/tmp` - directory to use for "scratch" space in Spark, including map output files and RDDs that get stored on disk.

## JDBC metastore (for Hive)

Default configuration uses Derby as JDBC metastore_db which is created relatively to the startup path. So to make container (namely spark-shell) to start right change to /tmp.

# Authors

 - Denis Baryshev (<dennybaa@gmail.com>)
