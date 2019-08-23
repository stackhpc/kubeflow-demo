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

ansible-playbook k8s.yml -e @variables/example.yml

``
