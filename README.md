[![Go to Docker Hub](https://img.shields.io/badge/Docker%20Hub-%E2%86%92-blue.svg)](https://hub.docker.com/r/actionml/spark/) [![](https://images.microbadger.com/badges/version/actionml/spark.svg)](https://microbadger.com/images/actionml/spark) [![](https://images.microbadger.com/badges/image/actionml/spark.svg)](https://microbadger.com/images/actionml/spark)

# Apache Spark docker container image (Standalone mode)

Standalone Spark cluster mode requires a dedicated instance called **master** to coordinate the cluster workloads. Therefore the usage of an additional cluster manager such as Mesos, YARN or Kubernetes is not necessary. However Standalone cluster can be used with all of these cluster managers. Additionally Standalone cluster mode is the most flexible to deliver Spark workloads for Kubernetes, since as of Spark **version 2.4.0** the native Spark Kubernetes support is still very limited.

## Starting up

Clone this repo and use *docker-compose* to bring up the sample standalone spark cluster.

```shell
docker-compose up
```

Note that the default configuration will expose ports `8080` and `8081` correspondingly for the master and the worker containers.

## Configuration

Standalone mode supports to container roles master and worker. Depending on which one you need to start you may pass either **master** or **worker** command to this container. Worker requires only one argument which is the spark host URL (`spark://host:7077`).

Fine-tune configuration maybe achieved by mounting `/spark/conf/spark-defaults.conf`, `/spark/conf/spark-env.sh` or by passing `SPARK_*` environment variables directly. See the links bellow for more details:

- [Spark Standalone](https://spark.apache.org/docs/latest/spark-standalone.html)
- [Spark configuration](https://spark.apache.org/docs/latest/configuration.html)

## Important: scratch volumes

- `/spark/work` - directory to use for scratch space and job output logs; only on worker. Can be overridden via `-w path` CLI argument.
- `/tmp` - directory to use for "scratch" space in Spark, including map output files and RDDs that get stored on disk (`spark.local.dir` setting).

# Authors

- Denis Baryshev (<dennybaa@gmail.com>)
