#!/bin/bash

# when combined with "ImagePull": "Always" this will repull the image being used
kubectl delete -f uiplugin.yaml
kubectl apply -f uiplugin.yaml
