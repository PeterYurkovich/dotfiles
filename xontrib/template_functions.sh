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
  if [ $? -ne 0 ]; then
    echo $template
    return 1
  fi

  export TEMPOSTACK_NAME="tempo-stack"
  export NAMESPACE_NAME="openshift-tempo-operator"
  export SECRET_NAME="secret-one"

  temp_file_location="$HOME/xontrib/yaml/tmp/tempo-$(date +%s).yaml"
  echo $template | envsubst > $temp_file_location
  unset TEMPOSTACK_NAME
  unset NAMESPACE_NAME
  unset SECRET_NAME
}

function get_namespace() {
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