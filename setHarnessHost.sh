#!/bin/bash
   HARNESS_HOST=`curl -s https://$KUBERNETES_SERVICE_HOST/api/v1/namespaces/default/pods/harness-0 --header "Authorization: Bearer $KUBE_TOKEN" --insecure | jq -r .status.podIP`
   HARNESS=`cat /etc/hosts | grep harness-0`
   
   if [ "$HARNESS" != ""]
   then
      sed -i "s|.*.harness-0|$HARNESS_HOST \tharness-0|g" /etc/hosts
   else
      echo "$HARNESS_HOST harness-0" >> /etc/hosts
   fi