#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

## Derived from:
#  https://github.com/apache/spark/blob/master/resource-managers/kubernetes/docker/src/main/dockerfiles/spark/Dockerfile
#
FROM openjdk:8-alpine3.8

ARG version
ARG release
LABEL com.actionml.spark.vendor=ActionML \
      com.actionml.spark.version=$version \
      com.actionml.spark.release=$release

ENV SPARK_HOME=/spark \
    SPARK_PGP_KEYS="12973FD0 FC8ED089"

RUN adduser -Ds /bin/bash -h ${SPARK_HOME} spark && \
    apk add --no-cache bash tini libc6-compat linux-pam krb5 krb5-libs && \
# download dist
    apk add --virtual .deps --no-cache curl tar gnupg && \
    cd /tmp && export GNUPGHOME=/tmp && \
    file=spark-${version}-bin-hadoop2.7.tgz && \
    curl --remote-name-all -w "%{url_effective} fetched\n" -sSL \
        https://archive.apache.org/dist/spark/spark-${version}/{${file},${file}.asc} && \
    gpg --keyserver pgpkeys.mit.edu --recv-key ${SPARK_PGP_KEYS} && \
    gpg --batch --verify ${file}.asc ${file} && \
# create spark home
    mkdir -p ${SPARK_HOME} && \
    tar -xzf ${file} --no-same-owner --strip-components 1 && \
    mv bin data examples jars sbin ${SPARK_HOME} && \
# cleanup
    apk --no-cache del .deps && ls -A | xargs rm -rf

COPY entrypoint.sh /

WORKDIR /tmp
ENTRYPOINT [ "/entrypoint.sh" ]

# Specify the User that the actual main process will run as
USER spark:spark
