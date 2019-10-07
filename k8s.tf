
variable "cluster_name" {
  type = string
  default = "k8s"
}

variable "external_network_name" {
  type = string
  default = "provision-net"
}

variable "fixed_network_name" {
  type = string
  default = "provision-net"
}

variable "fixed_subnet_name" {
  type = string
  default = "provision-net"
}

variable "keypair_name" {
  type = string
  default = "default"
}

variable "image_name" {
  type = string
  #default = "FedoraAtomic29-20190708"
  default = "Fedora-Atomic-27-20180419.0.x86_64"
}

variable "flavor_name" {
  type = string
  default = "C6420-Xeon6148-192"
}

provider "openstack" {
  cloud = "eiffel"
}

resource "openstack_containerinfra_clustertemplate_v1" "kubernetes_template" {
  name                  = "k8s"
  image                 = "${var.image_name}"
  coe                   = "kubernetes"
  flavor                = "${var.flavor_name}"
  master_flavor         = "${var.flavor_name}"
  docker_storage_driver = "overlay2"
  network_driver        = "flannel"
  server_type           = "vm"
  external_network_id   = "${var.external_network_name}"
  fixed_network         = "${var.fixed_network_name}"
  fixed_subnet          = "${var.fixed_subnet_name}"
  master_lb_enabled     = false
  public                = true
  floating_ip_enabled   = false
  labels = {
    cgroup_driver="cgroupfs"
    ingress_controller="traefik"
    tiller_enabled="true"
    tiller_tag="v2.14.3"
    monitoring_enabled="true"
    #kube_tag="v1.15.4" after upgrading to 8.1.0
    kube_tag="v1.14.6"
    cloud_provider_tag="v1.14.0"
    heat_container_agent_tag="train-dev"
  }
}

resource "openstack_containerinfra_cluster_v1" "cluster" {
  name                 = "${var.cluster_name}"
  cluster_template_id  = "${openstack_containerinfra_clustertemplate_v1.kubernetes_template.id}"
  master_count         = 1
  node_count           = 3
  keypair              = "${var.keypair_name}"
}
