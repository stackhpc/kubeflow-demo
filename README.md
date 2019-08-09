README
######

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

See variables/example.yml

Configure the login node
------------------------

You are required to do this before you run any other playbooks.

```
ansible-playbook host-configure.yml -i hosts -e @variables/example.yml
```

It will install various tools. It should be possible to use the openstack client
on the login node:

```
. ~/venv-openstack/bin/active
openstack coe cluster list
```

Configure volume provider
-------------------------

```
ansible-playbook manila.yml -i hosts -e @variables/example.yml
```

Deploy Kubeflow
---------------

```
ansible-playbook kubeflow.yml -i hosts -e @variables/example.yml
```
