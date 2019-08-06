
provider "openstack" {
  cloud = "default"
}

resource "openstack_containerinfra_clustertemplate_v1" "kubernetes_template" {
  name                  = "k8s-1.1.4.3-1"
  image                 = "FedoraAtomic29-20190429"
  coe                   = "kubernetes"
  flavor                = "general.v1.small"
  master_flavor         = "general.v1.tiny"
  docker_storage_driver = "overlay2"
  network_driver        = "flannel"
  server_type           = "vm"
  external_network_id   = "cumulus-internal"
  master_lb_enabled     = false
  floating_ip_enabled   = false
  labels = {
    cgroup_driver="cgroupfs"
    prometheus_monitoring="true"
    kube_tag="v1.14.3"
    cloud_provider_tag="v1.14.0"
  }
}

resource "openstack_containerinfra_cluster_v1" "k8sy-perry" {
  name                 = "k8sy-perry"
  cluster_template_id  = "${openstack_containerinfra_clustertemplate_v1.kubernetes_template.id}"
  master_count         = 1
  node_count           = 1
  keypair              = "will"
}

