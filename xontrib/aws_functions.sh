#!/bin/sh

# create a script which checks if we ware logged in with aws, and if not, login
function check_aws_login() {
  if aws configure get aws_access_key_id > /dev/null 2>&1
  then
    print -P "\n%F{green}AWS is already logged in%f\n"
    return
  fi
  copy_redhat
  osascript $HOME/xontrib/viscosity.applescript
  kdestroy
  kinit --keychain
  (cd ~/Documents/projects/local-copies/aws-automation && source venv/bin/activate && python aws-saml.py --region us-east-1)
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
  if [[ "$#" -ne 1 ]]; then
    echo "Bucket name required"
    return
  fi
  bucket_names=$(aws s3api list-buckets --output text --no-paginate | grep -oP '(?<=bucketName>)[^<]+')
  potential_user_buckets=$(echo $bucket_names | grep -oP "^$1")
  deletion_count=0
  for potential_user_bucket in $potential_user_buckets; do
    tag_string=$(aws s3api get-bucket-tagging --bucket $potential_user_bucket --no-paginate)
    tag_lines=$(echo $tag_string | grep -oP '(?<=TagSet>)[^<]+')
    for tag_line in $tag_lines; do
      tag_segment=$(echo $tag_line | grep -oP '(?<=Key>)[^<]+')
      if [[ $tag_segment == "UserCreator" ]]; then
        approval=$(echo $tag_line | grep -oP '(?<=Value>)[^<]+')
        if [[ $approval == $1 ]]; then
          # aws s3api delete-bucket --bucket $potential_user_bucket --no-paginate
          echo "Deleted Bucket: $potential_user_bucket"
          ((deletion_count++))
        fi
      fi
    done
  done
  echo "Sucessfully deleted $deletion_count bucket(s)"
}

function create_bucket() {
  if [[ $# -ne 2 ]]; then
    echo "Bucket and User name required to create bucket"
    return
  fi
  bucket_name=$1
  user_name=$2
  if [[ $bucket_name == "" || $user_name == "" ]]; then
    echo "Bucket and User name required to create bucket"
    return
  fi
  if [[ "$user_name" == "$bucket_name"+^[a-zA-Z0-9] ]]; then
    echo "Bucket name must start with user name"
    return
  fi
  bucket_names=$(aws s3api list-buckets --output text --no-paginate)
  if [[ $bucket_names == *$bucket_name* ]]; then
    echo "Bucket already exists"
    return
  fi
  aws s3api create-bucket --no-paginate --bucket $bucket_name --acl private > /dev/null
  tag_set="TagSet=[{Key=UserCreator,Value=$user_name}]"
  aws s3api put-bucket-tagging --no-paginate --bucket $bucket_name --tagging $tag_set
  echo "Bucket created"
}

