#!/bin/zsh

function oc_apply() {
  if [ -z "$1" ]; then
    echo "Must have a filename to apply"
    return 1
  fi
  if ! [ -f "$1" ]; then
    echo "File $1 does not exist"
    return 1
  fi
  if ! [ -x "$(command -v oc)" ]; then
    echo "oc is not installed"
    return 1
  fi
  if [ -z "$(oc apply -f @$1)" ]; then
    echo "Failed to apply"
    return 1
  fi
  return 0
}

function get_template() {
  if [ -z "$1" ]; then
    echo "Must have a template name to get"
    return 1
  fi
  # Load templates file from templtes folder
  template_location=$HOME/xontrib/yaml/
  env=$(env | grep REGISTRY_ORG)
  if [ -z "$env" ]; then
    echo "No REGISTRY_ORG set"
    return 1
  fi
  template_name=$env
  template_name+="-$1"
  template_name+=".yaml"
  if ! [ -f "$template_name" ]; then
    echo "Template $template_name does not exist"
    return 1
  fi
  return 0
}

