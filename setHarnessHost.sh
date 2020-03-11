#!/bin/bash

   POD_IP=`curl -s https://$KUBERNETES_SERVICE_HOST/api/v1/namespaces/default/pods/harness-0 --header "Authorization: Bearer $KUBE_TOKEN" --insecure | jq -r .status.podIP`
   
   TEMP_HOSTS=/harnesstool/newhosts
   echo "$(cat /etc/hosts)" > $TEMP_HOSTS
   HOSTS=`cat $TEMP_HOSTS | grep harness-0`
   
   if [ "$HOSTS" != "" ]
   then
      sed -i "s|.*.harness-0|$POD_IP \tharness-0|g" $TEMP_HOSTS
   else
      echo "$POD_IP harness-0" >> $TEMP_HOSTS
   fi

   echo "$(cat $TEMP_HOSTS)" > /etc/hosts

   echo "$(date '+%Y-%m-%d %T') Haness-0 IP: $POD_IP" >> /harnesstool/harness-host.log