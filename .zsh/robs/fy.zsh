function fyd() {
  time docker run -it -e PWD=$PWD -e HOME=$HOME -e TF_PLUGIN_CACHE_DIR=$HOME/.terraform.d/plugin-cache-docker -v $HOME:$HOME -w $PWD gcr.io/inshur-prod0-repo0/inshur-iac:latest bash -c "fy $*"
}
