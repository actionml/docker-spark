#!/bin/bash
set -e

# Set instance type master/worker/shell
INSTANCE=$1
default_opts="--properties-file /spark-defaults.conf"

# Execute spark service or given arguments (for ex. can enter bash)
case $1 in
master|worker)
    shift
    . "/spark-env"
    : ${SPARK_HOME:?must be set!}
    ${SPARK_HOME}/bin/spark-class $CLASS $default_opts $(spark_args $@)
  ;;
shell)
    shift
    : ${SPARK_HOME:?must be set!}
    ${SPARK_HOME}/bin/spark-shell $default_opts $@
  ;;
*)
    $@
  ;;
esac
