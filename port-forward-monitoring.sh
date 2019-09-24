#!/bin/bash
kubectl port-forward svc/prometheus-operator-grafana --address 0.0.0.0 3000:80 -n monitoring
