FROM java:8-jre-alpine
MAINTAINER Denis Baryshev <dennybaa@gmail.com>

ENV SPARK_VERSION 1.6.2
LABEL vendor=ActionML \
      version_tags="[\"1.6\",\"1.6.2\"]"

# Update alpine and install required tools
RUN apk update && apk add --update bash curl

# Fetch and unpack spark dist
RUN curl -L http://www.us.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop2.6.tgz \
      | tar -xzp -C /usr/local/ && \
        ln -s spark-${SPARK_VERSION}-bin-hadoop2.6 /usr/local/spark

ADD entrypoint.sh spark-defaults.conf /

ENV SPARK_USER spark
ENV SPARK_HOME /usr/local/spark

# Some env vars can be passed to alter the behaviour, for additional
# details please visit https://spark.apache.org/docs/latest/spark-standalone.html

VOLUME [ "/usr/local/spark/work" ]

EXPOSE 8080 8081 6066 7077 4040 7001 7002 7003 7004 7005 7006
ENTRYPOINT [ "/entrypoint.sh" ]
