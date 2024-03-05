#!/usr/bin/env xonsh


def oc_connect(connection_string = ''):
  if connection_string == '':
    connection_string = $(pbpaste)
  if connection_string == '':
    print("Connection string not provided and not in clipboard")
    return

  splits = connection_string.split()
  
  urls = [x for x in splits if x.startswith("https")]
  if len(urls) == 0:
    print("No URLs present in conneciton string")
    return
  url = urls[0]
  unique_url_segments = url.split("apps.", 1)
  if len(unique_url_segments) < 2:
    print("URL in wrong format")
    return
  unique_url_segment = unique_url_segments[1]
  login_url = f"https://api.{unique_url_segment}:6443"

  password = splits[-1]

  oc_login_command = f"oc login {login_url} -u kubeadmin -p {password}"
  oc login @(login_url) -u kubeadmin -p @(password)

def get_bucket_names():
  buckets = $(aws s3api list-buckets --output text --no-paginate).splitlines()
  bucket_names = [x.split()[2] for x in buckets]
  return bucket_names

def delete_buckets(owner_name = ''):
  if owner_name == '':
    print("No username provided")
    return
  bucket_names = get_bucket_names()
  potential_user_buckets = [x for x in bucket_names if x.startswith(owner_name)]
  deletion_count = 0
  for potential_user_bucket in potential_user_buckets:
    tag_string = $(aws s3api get-bucket-tagging --bucket @(potential_user_bucket) --no-paginate)
    tag_lines = tag_string.splitlines()
    for tag_line in tag_lines:
      tag_segment = tag_line.split()
      if tag_segment[1] == 'UserCreator' and tag_segment[2] == owner_name:
        approval = input(f"Confirm Deletion of {potential_user_bucket}: (y/n)")
        if approval == 'y':
          aws s3api delete-bucket --bucket @(potential_user_bucket) --no-paginate
          print(f"Deleted Bucket: {potential_user_bucket}")
          deletion_count += 1
        # at this point just asume any non-yes is a no
  print(f"Sucessfully deleted {deletion_count} bucket(s)")

def create_bucket(bucket_name = '', user_name = ''):
  if bucket_name == '' or user_name == '':
    print("Bucket and User name required to create bucket")
    return False
  if not bucket_name.startswith(user_name):
    print("Bucket name must start with user name")
    return False
  bucket_names = get_bucket_names()
  if bucket_name in bucket_names:
    print("Bucket already exists")
    return True
  aws s3api create-bucket --no-paginate --bucket @(bucket_name) --acl private > /dev/null
  tag_set = "TagSet=[{Key=UserCreator,Value=" + user_name + "}]"
  aws s3api put-bucket-tagging --no-paginate --bucket @(bucket_name) --tagging @(tag_set)
  return True
