FROM dennybaa/debian-jvm:oracle8
MAINTAINER Denis Baryshev <dennybaa@gmail.com>

# Fetch and unpack spark dist
RUN wget -qO- http://www.us.apache.org/dist/spark/spark-1.6.1/spark-1.6.1-bin-hadoop2.6.tgz \
      | tar -xzp -C /usr/local/ && \
        ln -s spark-1.6.1-bin-hadoop2.6 /usr/local/spark

ADD entrypoint.sh spark-defaults.conf /

ENV SPARK_USER spark
ENV SPARK_HOME /usr/local/spark

# Some env vars can be passed to alter the behaviour, for additional
# details please visit https://spark.apache.org/docs/latest/spark-standalone.html

EXPOSE 8080 8081 6066 7077 4040 7001 7002 7003 7004 7005 7006
ENTRYPOINT [ "/entrypoint.sh" ]
