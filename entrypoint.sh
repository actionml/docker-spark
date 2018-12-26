#!/bin/bash
set -e

## Defaults
#
: ${SPARK_HOME:?must be set!}

## Load spark-env.sh Spark environment configuration variables
SPARK_CONF_DIR="${SPARK_CONF_DIR:-"${SPARK_HOME}/conf"}"
[ ! -f ${SPARK_CONF_DIR}/spark-env.sh ] || . ${SPARK_CONF_DIR}/spark-env.sh

## Invocation shortcut commands
#
cmd=$1
case $cmd in
master|worker)
    shift
    set -- ${SPARK_HOME}/bin/spark-class "org.apache.spark.deploy.${cmd}.${cmd^}" "$@"
    exec /sbin/tini -- "$@" -i 0.0.0.0
  ;;
spark-shell|shell)
    shift
    exec /sbin/tini -- ${SPARK_HOME}/bin/spark-shell "$@"
  ;;
*)
    # Run an arbitary command
    [ -n "$*" ] && exec "$@" || exec /bin/bash
  ;;
esac
