function podname () {
  namespace=${1}
  pod=$2

  pod_id=$(kubectl get pods -n $namespace -o name | cut -d\/ -f2- | grep $pod)

  if [[ -z "$pod_id" ]]; then
    echo "pod not found: ${namespace}/${pod}"
  else
    echo $pod_id
  fi
}

#$(kubectl get pods --namespace monitoring -l app=influxdb-influxdb -o jsonpath='{ .items[0].metadata.name  }')

function klog () {
  namespace=${1:-default}
  pod=$2

  kubectl logs -f --namespace $namespace $(podname $namespace $pod)
}

function kexec () {
  namespace=${1}
  pod=$2
  command=${3:-/bin/bash}

  kubectl exec --namespace $namespace $(podname $namespace $pod) -ti -- $command
}

function kcluster () {
  project=$(echo $1 | awk -F\/ '{ print $1 }')
  cluster=$(echo $1 | awk -F\/ '{ print $2 }')

  zone=${2:-europe-west1-b}

  if [[ -z $cluster ]]; then
    kcluster-list $project
    return
  fi

  gcloud container clusters get-credentials $cluster \
    --zone $zone --project $project

  if [[ $? -ne 0 ]]; then
    echo
    kcluster-list $project
    return
  fi
}

function kcluster-list () {
  project=$1

  gcloud container clusters list --project $project --format json | jq -r '.[].name'
}
