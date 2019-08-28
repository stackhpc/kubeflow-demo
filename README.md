# README


```
ansible-galaxy install -r requirements.yml -p roles/
```

We assume you are clouds.yml, if not you can create one using:

```
. ~/path-to-openrc
ansible-playbook cloud-config.yml
```

Install terraform
-----------------

- install go
- `go get github.com/hashicorp/terraform`
- `go get github.com/terraform-providers/terraform-provider-template`

Create cluster
--------------
```
./terraform init
./terraform apply
```

Edit variable overrides
-----------------------

See `variables/example.yml`

Run the playbook
----------------

```
ansible-playbook k8s.yml -e @variables/example.yml

```

# Manully fixups

node exporter broken
---------------------

```
[fedora@k8sy-perry-ljbdnfdar6hf-master-0 ~]$ cd /srv/magnum/kubernetes/monitoring/

[fedora@k8sy-perry-ljbdnfdar6hf-master-0 ~]kubectl delete -f nodeExporter.yaml

[(os-venv) [stackhpc@seed local]$ ~]helm install --name monitoring stable/prometheus-node-exporter --namespace monitoring
```

grafana unconfigued
--------------------

- manually add prometheus datasource using port from `kubectl get svc`
- manually import https://grafana.net/api/dashboards/1621/revisions/1/download"

mnist example
-------------

These snippets may come in useful:
```

export DOCKER_URL=docker.io/gwee/kubeflow-examples:1.0
export PVC_NAME=mnist

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mnist
  namespace: kubeflow
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: nfs-client
  resources:
    requests:
      storage: 20Gi

```

