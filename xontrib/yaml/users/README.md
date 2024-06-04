# Htpasswd

This directory contains the basic htpasswd setup for peter and pyn with a password of `password`.

The `htpasswd` command is used to create a new user and set a password.


## Updating the secret
To create the secret you can run the following command:

```bash
oc create secret generic httpass-secret --from-file=htpasswd=auth.htpasswd -n openshift-config
```

or you can update the `secret.yaml` file in this directory by base64 encoding the auth.htpasswd file and adding it as the final parameter in the `secret.yaml` file.

```bash
base64 auth.htpasswd
```
