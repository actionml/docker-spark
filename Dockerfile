FROM java:8-jre-alpine
MAINTAINER Denis Baryshev <dennybaa@gmail.com>

ENV GOSU_VERSION 1.9
ENV SPARK_VERSION 1.6.2
ENV SPARK_HOME /usr/local/spark
ENV SPARK_USER spark

LABEL vendor=ActionML \
      version_tags="[\"1.6\",\"1.6.2\"]"

# Update alpine and install required tools
RUN apk add --update --no-cache bash curl gnupg

# Get gosu
RUN curl -sSL -o /usr/local/bin/gosu && chmod 755 /usr/local/bin/gosu \
        https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64 \
    && curl -sSL -o /tmp/gosu.asc https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc \
    && export GNUPGHOME=/tmp \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /tmp/gosu.asc /usr/local/bin/gosu \
    && rm -r /tmp/*

# Fetch and unpack spark dist
RUN curl -L http://www.us.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop2.6.tgz \
      | tar -xzp -C /usr/local/ && \
        ln -s spark-${SPARK_VERSION}-bin-hadoop2.6 ${SPARK_HOME}

# Create users (to go "non-root") and set directory permissions
RUN useradd -mU -d /home/hadoop hadoop && passwd -d hadoop && \
    useradd -mU -d /home/spark -G hadoop spark && passwd -d spark && \
    chown -R spark:hadoop ${SPARK_HOME}

ADD entrypoint.sh spark-defaults.conf /

# Some env vars can be passed to alter the behaviour, for additional
# details please visit https://spark.apache.org/docs/latest/spark-standalone.html

VOLUME [ "/usr/local/spark/work", "/usr/local/spark/tmp" ]

EXPOSE 8080 8081 6066 7077 4040 7001 7002 7003 7004 7005 7006
ENTRYPOINT [ "/entrypoint.sh" ]
