#!/bin/bash
kubectl port-forward svc/ambassador --address 0.0.0.0 8080:80 -n kubeflow
