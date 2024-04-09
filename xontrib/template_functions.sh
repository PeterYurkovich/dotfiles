#!/bin/zsh

function get_template() {
  if [ -z "$1" ]; then
    echo "Must have a template name to get"
    return 1
  fi
  # Load templates file from templtes folder
  template_location=$HOME/xontrib/yaml/
  template_location+="$1"

  if ! [ -f "$template_location" ]; then
    echo "Template at $template_location does not exist"
    return 1
  fi
  cat $template_location
}

function get_tempo() {
  template=$(get_template "tempo/templates/tempostack-template.tmpl")
  if [ $? -ne 0 ]; then echo $template; return 1; fi

  export TEMPOSTACK_NAME="tempo-stack"
  export NAMESPACE_NAME="openshift-tempo-operator"
  export SECRET_NAME="secret-one"

  temp_file_location="$HOME/xontrib/yaml/tmp/tempo-$(date +%s).yaml"
  echo $template | envsubst > $temp_file_location
  unset TEMPOSTACK_NAME
  unset NAMESPACE_NAME
  unset SECRET_NAME
}

function create_namespace() {
  if [ -z "$1" ]; then
    echo "Must have a namespace name to get"
    return 1
  fi

  template=$(get_template "templates/namespace-template.tmpl")
  if [ $? -ne 0 ]; then
    echo $template
    return 1
  fi

  export NAMESPACE_NAME=$1

  temp_file_location="$HOME/xontrib/yaml/tmp/namespace-$(date +%s).yaml"
  echo $template | envsubst > $temp_file_location

  unset NAMESPACE_NAME

  kaf $temp_file_location
}

function install_tempo() {
  kaf "$HOME/xontrib/yaml/tempo/operator-project.yaml"
  if [ $? -ne 0 ]; then
    echo "Failed to add the operator project"
    return 1
  fi

  kaf "$HOME/xontrib/yaml/tempo/operator-group.yaml"
  if [ $? -ne 0 ]; then
    echo "Failed to create the operator group"
    return 1
  fi

  echo "Sleeping for 10 seconds to let the operator load"
  sleep 10

  kaf "$HOME/xontrib/yaml/tempo/subsciption.yaml"
  if [ $? -ne 0 ]; then
    echo "Failed to create operator subscription"
    return 1
  fi
}

function create_tempo_instance() {
  if [ -z "$1" ]; then
    echo "Must have specified postfix"
    return 1
  fi

  export AWS_REGION=$(aws configure get region)
  export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
  export AWS_ACCESS_KEY_SECRET=$(aws configure get aws_secret_access_key)

  export AWS_BUCKET_NAME="pyurkovi-tempo-$1"
  export AWS_S3_ENDPOINT="https://s3.$region.amazonaws.com"
  export SECRET_NAME="secret-$1"
  export TEMPOSTACK_NAME="tempo-stack-$1"
  NAMESPACE="openshift-tempo-operator"
  if [ "$1" != "one" ]; then
    NAMESPACE+="-" + "$1"
    if ! create_namespace "$NAMESPACE"; then
      echo "Failed to create namespace: $NAMESPACE"
      return 1
    fi
  fi
  export NAMESPACE

  secret_template=$(get_template "templates/secret-template.tmpl")
  if [ $? -ne 0 ]; then echo $secret_template; return 1; fi

  temp_file_location="$HOME/xontrib/yaml/tmp/secret-$(date +%s).yaml"
  echo $secret_template | envsubst > $temp_file_location

  if [ $? -ne 0 ]; then echo "Fialed to Create Secrete yaml"; return 1; fi

  if ! kaf $temp_file_location; then
    echo "Failed to create secret with name: $SECRET_NAME"
    return 1
  fi

  tempostack_template=$(get_template "tempo/templates/tempostack-template.tmpl")
  if [ $? -ne 0 ]; then echo "Failed to get tempostack template"; return 1; fi

  temp_file_location="$HOME/xontrib/yaml/tmp/tempostack-$(date +%s).yaml"
  echo $tempostack_template | envsubst > $temp_file_location

  if [ $? -ne 0 ]; then echo "Failed to create tempostack with name: $TEMPOSTACK_NAME"; return 1; fi

  if ! kaf $temp_file_location; then
    echo "Failed to create tempostack with name: $TEMPOSTACK_NAME"
    return 1
  fi
}