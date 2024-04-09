#!/bin/zsh

# create a script which checks if we ware logged in with aws, and if not, login
function check_aws_login() {
  if aws sts get-caller-identity | grep -q "ExpiredToken"
  then
    print -P "\n%F{green}AWS is already logged in%f\n"
    return
  fi
  vpn_connect
  kdestroy
  kinit --keychain
  (cd ~/Documents/projects/local-copies/aws-automation && source venv/bin/activate && python aws-saml.py --region us-east-1)
}

function vpn_connect() {
  copy_redhat
  osascript $HOME/xontrib/viscosity.applescript
}

function authenticate_bitwarden() {
  if ! bw unlock --check > /dev/null 2>&1
  then
    print -P "\n%F{red}Vault is locked.%f\n"
    print -P "%F{green}Unlocking Bitwarden%f\n"
    export BW_SESSION="$(bw unlock --raw)"
  else 
    print -P "\n%F{green}Vault is already unlocked%f\n"
  fi
}

function copy_redhat() {
  authenticate_bitwarden
  REDHAT_LOGIN=$(bw get item sso.redhat.com | jq '.login.password' -r)
  REDHAT_LOGIN+=$(bw get totp sso.redhat.com)
  echo $REDHAT_LOGIN | pbcopy
  print -P "\n%F{yellow}Red Hat login copied to clipboard%f\n"
}

function delete_buckets() {
  check_aws_login
  if [[ "$#" -ne 1 ]]; then
    print -P "\n%F{red}User name required%f\n"
    return
  fi
  USER_NAME=$1
  potential_user_buckets=$(aws s3api list-buckets --output json --no-paginate | jq -r ".Buckets[].Name | select(startswith(\"$USER_NAME\"))")
  deletion_count=0
  for potential_user_bucket in $potential_user_buckets; do
    tag_string=$(aws s3api get-bucket-tagging --bucket $potential_user_bucket --output json --no-paginate)
    USER_CREATOR=$(echo $tag_string | jq '.TagSet[] | select(.Key == "UserCreator")' | jq -r '.Value')
    if [ -z "$USER_CREATOR" ]; then
      continue
    fi
    # confirm delete
    print -n -P "\n%F{yellow}Delete bucket $potential_user_bucket? (y/n): %f"
    read APPROVAL
      if [[ $APPROVAL == "y" ]]; then
      aws s3api delete-bucket --bucket $potential_user_bucket --no-paginate
      echo "Deleted Bucket: $potential_user_bucket"
      ((deletion_count++))
    fi
  done
  echo "Sucessfully deleted $deletion_count bucket(s)"
}

function create_bucket() {
  check_aws_login
  if [[ $# -ne 2 ]]; then
    print -P "\n%F{red}Bucket and User name required to create bucket%f\n"
    return
  fi
  bucket_name=$1
  user_name=$2
  if [[ $bucket_name == "" || $user_name == "" ]]; then
    print -P "\n%F{red}Bucket and User name required to create bucket%f\n"
    return
  fi
  if [[ "$user_name" == "$bucket_name"+^[a-zA-Z0-9] ]]; then
    print -P "\n%F{red}Bucket name must start with user name%f\n"
    return
  fi
  bucket_names=$(aws s3api list-buckets --output text --no-paginate)
  if [[ $bucket_names == *$bucket_name* ]]; then
    print -P "%F{green}Bucket already exists%f\n"
    return
  fi
  if aws s3api create-bucket --bucket $bucket_name --acl private > /dev/null
  then
    print -P "%F{green}Bucket created%f\n"
    tag_set="TagSet=[{Key=UserCreator,Value=$user_name}]"
    if aws s3api put-bucket-tagging --no-paginate --bucket $bucket_name --tagging $tag_set
    then
      print -P "%F{green}Bucket tagged%f\n"
    else
      print -P "\n%F{red}Bucket tagging failed%f\n"
    fi
  else
    print -P "\n%F{red}Bucket creation failed%f\n"
  fi
}

