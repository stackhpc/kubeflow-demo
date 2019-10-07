# README

Configure clouds.yml
--------------------

We assume you are clouds.yml, if not you can create one using:

    ansible-galaxy install -r requirements.yml -p roles/
    . ~/path-to-openrc
    ansible-playbook cloud-config.yml

Upload Fedora Atomic image
--------------------------

Support for Fedora Atomic 29 on Stein release (8.0.0) is broken. Hence we use
Fedora Atomic 27 for now. The newer version will be supported on the next Stein
release (8.1.0) where fixes have been backported from the master branch.

    ./upload-image.sh

Install terraform
-----------------

- install `go` if not installed
- `go get github.com/hashicorp/terraform`
- `go get github.com/terraform-providers/terraform-provider-template`

Create cluster
--------------

    ./terraform init
    ./terraform apply

Edit variable overrides
-----------------------

See `variables/example.yml`

Run the playbook
----------------

For the playbook to be able to use `tiller` deployed in `magnum-tiller` namespace,

    source magnum-tiller.sh

Then run,

    ansible-playbook k8s.yml -e @variables/example.yml


mnist example
-------------

These snippets may come in useful for building the image:

    export DOCKER_URL=docker.io/gwee/kubeflow-examples:1.0
    export PVC_NAME=mnist

To try the exmaple, clone our fork of `kubeflow-examples` which has our local
`kustomizations`:

    git clone https://github.com/stackhpc/kubeflow-examples examples -b dell
    cd examples/mnist && bash deploy-kustomizations.sh
