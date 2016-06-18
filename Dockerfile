FROM debian:jessie
MAINTAINER Denis Baryshev <dennybaa@gmail.com>

ENV SPARK_USER aml
RUN adduser --disabled-login --gecos "" $SPARK_USER

RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" \
      >/etc/apt/sources.list.d/webupd8team-java.list && \
    echo "debconf shared/accepted-oracle-license-v1-1 select true" | /usr/bin/debconf-set-selections && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886

# Install dependencies, we use Oracle java 8
RUN apt-get update -y && apt-get install -y \
      wget oracle-java8-installer oracle-java8-set-default


# Fetch and unpack spark dist
RUN wget -qO- http://www.eu.apache.org/dist/spark/spark-1.6.1/spark-1.6.1-bin-hadoop2.6.tgz \
      | tar -xz -C /usr/local/ && \
        ln -s spark-1.6.1-bin-hadoop2.6 /usr/local/spark

# Chown as aml spark home (it's symlinked)
RUN chown -R $SPARK_USER.$SPARK_USER /usr/local/spark-1.6.1-bin-hadoop2.6

ADD entrypoint.sh spark-defaults.conf /

ENV SPARK_HOME /usr/local/spark


# Some env vars can be passed to alter the behaviour, for additional
# details please visit https://spark.apache.org/docs/latest/spark-standalone.html

EXPOSE 8080 8081 6066 7077 4040 7001 7002 7003 7004 7005 7006
ENTRYPOINT [ "/entrypoint.sh" ]
