from jinja2 import Environment, FileSystemLoader
import time
from aws_functions import create_bucket

home_path = '/Users/pyurkovi/'
aws_username = 'pyurkovi'

def oc_apply(filename = ''):
  if filename == '':
    print("Must have a filename to apply")
    return False
  if not !(oc apply -f @(filename)):
    print("Failed to apply")
    return False
  return True

def get_template(template_name = ''):
  if template_name == '':
    print("Invalid template name")
    return False
  # Load templates file from templtes folder
  template_location = home_path + '/xontrib/yaml/'
  env = Environment(loader=FileSystemLoader(searchpath=template_location), trim_blocks=True, lstrip_blocks=True)
  return env.get_template(template_name)

def create_namespace(namespace_name = ''):
  if namespace_name == '':
    print("Please provide a namespace name")
    return False
  template = get_template("templates/namespace-template.j2")
  rendered_template = template.render(namespace_name=namespace_name)
  template_filename = home_path + "/xontrib/yaml/tmp/namespace" + str(time.time_ns()) + ".yaml"
  with open(template_filename, "w+") as file:
    file.write(rendered_template)
  return oc_apply(template_filename)

def install_tempo():
  if not oc_apply(home_path + "/xontrib/yaml/tempo/operator-project.yaml"):
    print("Failed to add the operator project")
    return False
  if not oc_apply(home_path + "/xontrib/yaml/tempo/operator-group.yaml"):
    print("Failed to create the operator group")
    return False
  print("Sleeping for 10 seconds to let the operator load")
  time.sleep(10)
  if not oc_apply(home_path + "/xontrib/yaml/tempo/subsciption.yaml"):
    print("Failed to create operator subscription")
    return False
  return True

def create_tempo_instance(postfix = ''):
  if postfix == '':
    print("Must have specified postfix")
    return False

  region = $(aws configure get region).rstrip()
  access_key_id = $(aws configure get aws_access_key_id).rstrip()
  secret_access_key = $(aws configure get aws_secret_access_key).rstrip()
  bucket_name = f"{aws_username}-tempo-{postfix}"
  endpoint = f"https://s3.{region}.amazonaws.com"
  secret_name = f"secret-{postfix}"
  tempostack_name = f"tempo-stack-{postfix}"
  namespace = 'openshift-tempo-operator'
  if postfix != 'one':
    namespace = namespace + '-' + postfix
    if not create_namespace(namespace):
      print(f"Failed to create namespace: {namespace}")
      return False

  secret_template = get_template("templates/secret-template.j2")
  rendered_secret_template = secret_template.render({
    'secret_name': secret_name,
    'region': region,
    'bucket_name': bucket_name,
    'bucket_names': bucket_name,
    'access_key_id': access_key_id,
    'access_key_secret': secret_access_key,
    'endpoint': endpoint,
    'namespace': namespace,
  })

  tempostack_template = get_template("tempo/templates/tempostack-template.j2")
  rendered_tempostack_template = tempostack_template.render({
    'tempostack_name': tempostack_name,
    'namespace_name': namespace,
    'secret_name': secret_name
  })

  if not create_bucket(bucket_name, aws_username):
    print("Bucket Unable to be created")
    return False

  secret_filename = f"{home_path}/xontrib/yaml/tmp/secret{str(time.time_ns())}.yaml"
  with open(secret_filename, "w+") as secret_file:
    secret_file.write(rendered_secret_template)
  if not oc_apply(secret_filename):
    print(f"Failed to create secret with name: {secret_name}")
    return False

  tempostack_filename = f"{home_path}/xontrib/yaml/tmp/secret{str(time.time_ns())}.yaml"
  with open(tempostack_filename, "w+") as tempostack_file:
    tempostack_file.write(rendered_tempostack_template)
  if not oc_apply(tempostack_filename):
    print(f"Failed to create tempostack with name: {tempostack_name}")
    return False
  return True
