# Docker container for spark (standalone cluster)

## Starting up

This repository contains a set of scripts and configuration files to run a [Apache Spark](https://spark.apache.org/) standalone cluster from [Docker](https://www.docker.io/) container.

To start master, workers or shell (on the same docker host),  you can invoke the following commands:

```
# Spawn master
docker run -d --name spark-master dennybaa/spark master
master_ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' spark-master)

# Spawn workers
docker run -d --name spark-worker0 dennybaa/spark worker spark://$master_ip:7077
docker run -d --name spark-worker1 dennybaa/spark worker spark://$master_ip:7077

# Spawn shell
docker run --rm -it dennybaa/spark shell --master spark://$master_ip:7077
```

## Configuration

There's a set of environment variables and command line arguments which can be passed to the spark container. Please refer to [spark documentation](http://spark.apache.org/docs/latest/configuration.html) for additional information, the list of environment variables recognized by spark can be found here - [cluster launch scripts](https://spark.apache.org/docs/latest/spark-standalone.html#cluster-launch-scripts).

### Other

If you are planning to use spark shell, it's advised to look at [Zeppelin](https://zeppelin.incubator.apache.org/), it could be used instead of spark shell for working with data. It has pleasant GUI and IPython like functionality.
