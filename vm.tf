# Создание виртуальной машины для master-ноды
resource "yandex_compute_instance" "k8s_master" {
  name        = local.master_node.name
  platform_id = local.common_vm_settings.platform_id
  zone        = var.default_zone

  resources {
    cores         = local.master_node.cores
    memory        = local.master_node.memory
    core_fraction = local.master_node.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_image_id
      size     = local.common_vm_settings.disk_size
    }
  }

  network_interface {
    subnet_id          = var.existing_subnet_ids[var.default_zone].id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.k8s_security_group.id]
  }

  metadata = {
    ssh-keys  = "${var.vm_user}:${var.ssh_public_key}"
    user-data = <<-EOF
      #cloud-config
      timezone: ${local.common_vm_settings.timezone}
      users:
        - name: ${var.vm_user}
          groups: sudo
          shell: /bin/bash
          sudo: ['ALL=(ALL) NOPASSWD:ALL']
          ssh-authorized-keys:
            - ${var.ssh_public_key}
      EOF
  }

  service_account_id = var.service_account_id
}

# Создание виртуальных машин для worker-нод
resource "yandex_compute_instance" "k8s_worker" {
  count       = local.worker_nodes.count
  name        = "${local.worker_nodes.name_prefix}-${count.index + 1}"
  platform_id = local.common_vm_settings.platform_id
#  zone        = var.public_subnet_zones[count.index % length(var.public_subnet_zones)]
#   zone        = var.public_subnet_zones[count.index] # Используем соответствующую зону 
  zone        = var.public_subnet_zones[count.index % length(var.public_subnet_zones)]

  resources {
    cores         = local.worker_nodes.cores
    memory        = local.worker_nodes.memory
    core_fraction = local.worker_nodes.core_fraction
  }

  scheduling_policy {
    preemptible = local.worker_nodes.preemptible
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_image_id
      size     = local.common_vm_settings.disk_size
    }
  }

  network_interface {
    subnet_id          = var.existing_subnet_ids[var.public_subnet_zones[count.index % length(var.public_subnet_zones)]].id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.k8s_security_group.id]
  }

  metadata = {
    ssh-keys  = "${var.vm_user}:${var.ssh_public_key}"
    user-data = <<-EOF
      #cloud-config
      timezone: ${local.common_vm_settings.timezone}
      users:
        - name: ${var.vm_user}
          groups: sudo
          shell: /bin/bash
          sudo: ['ALL=(ALL) NOPASSWD:ALL']
          ssh-authorized-keys:
            - ${var.ssh_public_key}
      EOF
  }

  service_account_id = var.service_account_id
}
