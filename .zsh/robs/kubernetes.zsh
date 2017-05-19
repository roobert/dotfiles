function podname () {
  pod=$1
  namespace=${2:-default}

  pod_id=$(kubectl get pods -n $namespace -o name | cut -d\/ -f2- | grep $pod)

  if [[ -z "$pod_id" ]]; then
    echo "pod not found: ${namespace}/${pod}"
  else
    echo $pod_id
  fi
}

#$(kubectl get pods --namespace monitoring -l app=influxdb-influxdb -o jsonpath='{ .items[0].metadata.name  }')

function klog () {
  pod=$1
  namespace=${2:-default}

  kubectl logs -f --namespace $namespace $(podname $pod $namespace)
}

function kexec () {
  pod=$1
  command=${2:-/bin/bash}
  namespace=${3:-default}

  kubectl exec --namespace $namespace $(podname $pod $namespace) -ti -- $command
}
