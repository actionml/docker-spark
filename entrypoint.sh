#!/bin/bash
set -e

# Check if CLI args list containes bind address key.
cli_bind_address() {
  echo "$*" | grep -qE -- "--host\b|-h\b|--ip\b|-i\b"
}


# Set instance type master/worker/shell
default_opts="--properties-file /spark-defaults.conf"

# Basic configs sourcing
: ${SPARK_HOME:?must be set!}
. "${SPARK_HOME}/sbin/spark-config.sh"
. "${SPARK_HOME}/bin/load-spark-env.sh"


# Execute spark service or given arguments (for ex. can enter bash)
case $1 in
master|worker)
    instance=$1
    shift
    CLASS="org.apache.spark.deploy.$instance.${instance^}"

    # Handle custom bind address, we make it 0.0.0.0 as the default one.
    if ( ! cli_bind_address $@  ); then
      eval bind_address=\$SPARK_${instance^^}_IP
      : ${bind_address:=0.0.0.0}
      default_opts="${default_opts} --host ${bind_address}"
    fi

    echo "spark-class invocation arguments: $default_opts $@"
    ${SPARK_HOME}/bin/spark-class $CLASS $default_opts $@
  ;;
shell)
    shift
    echo "spark-shell invocation arguments: $default_opts $@"
    ${SPARK_HOME}/bin/spark-shell $default_opts $@
  ;;
*)
    $@
  ;;
esac
