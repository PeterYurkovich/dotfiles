# Create User

This directory contains the basic htpasswd setup for user "user" with a password of `password`.

## Using htpasswd
The `htpasswd` command is used to create and update user and password combinations. 

The following command can be used to create or update a user in the htpasswd file.

```
htpasswd -c -B -b users.htpasswd user password
```

## OpenShift
To use the generated htpasswd file to authenticate a user, you need to add the file as a secret then let the OpenShift know that it should use it for login.

### Adding the secret
First the updated htpasswd file needs to be added to the secret. It expects a base64 encoded string, so run the following command:

```bash
base64 users.htpasswd
```

Then copy the output and put it in `secret.yaml` as the final parameter. Then add that secret into OpenShift using:

```bash
oc apply -f secret.yaml
```

Alternatively, you can directly pass in the htpasswd file rather than manually updating the secret:

```bash
oc create secret generic httpass-secret --from-file=htpasswd=users.htpasswd -n openshift-config
```

### Using the secret
Apply the oauth configuration file:

```bash
oc apply -f htpasswd.yaml
```

