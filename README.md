# README


```
ansible-galaxy install -r requirements.yml -p roles/
```

We assume you are clouds.yml, if not you can create one using:

```
. ~/path-to-openrc
ansible-playbook cloud-config.yml
```

Upload Fedora Atomic image
--------------------------

Support for Fedora Atomic 29 on Stein release (8.0.0) is broken. Hence we use
Fedora Atomic 27 for now. The newer version will be supported on the next Stein
release (8.1.0) where fixes have been backported from the master branch.

```
./upload-image.sh
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

For the playbook to be able to use helm,

```
source magnum-tiller.sh
```

Then run,

```
ansible-playbook k8s.yml -e @variables/example.yml

```

Forward port
------------

```
./port-forward.sh

```

Then navigate to port 3000 to view the grafana dashboard.


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

monitoring ingress
------------------

```
kubectl edit cm/prometheus-operator-grafana -n monitoring
```
Then put in:
```
[server]
root_url = %(protocol)s://%(domain)s:%(http_port)s/grafana/
```
