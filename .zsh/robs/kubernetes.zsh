if which kubectl > /dev/null 2>&1; then
  source <(kubectl completion zsh | sed -e '/flaghash.*true/s/# pad/2>\/dev\/null # pad/')
fi

function kpodname () {
  namespace=${1}
  pod=$2

  # FIXME: only return one id
  pod_id=$(kubectl get pods -a -n $namespace -o name | cut -d\/ -f2- | grep $pod | head -n1)

  if [[ -z "$pod_id" ]]; then
    echo "pod not found: ${namespace}/${pod}"
  else
    echo $pod_id
  fi
}

function kpods () {
  namespace=${1:=default}

  kubectl get pods -a --namespace $1
}

function knamespaces () {
  kubectl get namespaces
}


function klog () {
  namespace=${1:-default}
  pod=$2

  kubectl logs -f --namespace $namespace $(kpodname "$namespace" "$pod")
}

function kexec () {
  namespace=${1}
  pod=$2
  command=${3:-/bin/bash}

  kubectl exec --namespace $namespace $(kpodname "$namespace" "$pod") -ti -- $command
}

function kcluster () {

  if [[ $1 == "." ]]; then
    project=$(echo $PWD | sed 's/.*conf\///' | cut -d\/ -f 1)
    cluster=$(echo $PWD | sed 's/.*conf\///' | cut -d\/ -f 2)
  elif [[ $1 == "-" ]]; then
    project=$(cat ~/.kcluster | cut -d\/ -f1)
    cluster=$(cat ~/.kcluster | cut -d\/ -f2)
  else
    project=$(echo $1 | awk -F\/ '{ print $1 }')
    cluster=$(echo $1 | awk -F\/ '{ print $2 }')
  fi

  echo "${K8S_CURRENT_CONTEXT_PROJECT}/${K8S_CURRENT_CONTEXT_CLUSTER}" > ~/.kcluster

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

function kdir () {
  cd ${HOME}/git/kuber/conf/${K8S_CURRENT_CONTEXT_PROJECT}/${K8S_CURRENT_CONTEXT_CLUSTER}
}
