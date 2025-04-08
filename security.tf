resource "yandex_vpc_security_group" "k8s_security_group" {
  name        = "k8s-security-group"
  description = "Security group for Kubernetes cluster"
  network_id  = var.existing_vpc_id

  ingress {
    protocol       = "ANY"
    description    = "Full internal cluster communication"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24", "192.168.30.0/24"]
    from_port      = 0
    to_port        = 65535
  }

  ingress {
    protocol       = "TCP"
    description    = "Kubernetes API server"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24", "192.168.30.0/24"]
    port           = 6443
  }

  ingress {
    protocol       = "TCP"
    description    = "etcd client API"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24", "192.168.30.0/24"]
    port           = 2379
  }

  ingress {
    protocol       = "TCP"
    description    = "etcd peer API"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24", "192.168.30.0/24"]
    port           = 2380
  }

  ingress {
    protocol       = "TCP"
    description    = "Kubelet API"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24", "192.168.30.0/24"]
    port           = 10250
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTPS"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  ingress {
    protocol       = "TCP"
    description    = "SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "NodePort range"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 30000
    to_port        = 32767
  }

  ingress {
    protocol       = "TCP"
    description    = "Grafana"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 30090
  }

  ingress {
    protocol       = "TCP"
    description    = "Prometheus"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 30091
  }

  ingress {
    protocol       = "TCP"
    description    = "Alertmanager"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 30092
  }

  egress {
    protocol       = "ANY"
    description    = "Outbound traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }

  ingress {
    protocol       = "TCP"
    description    = "NodePort1"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 30080
  }

  ingress {
    protocol       = "TCP"
    description    = "NodePort2"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 30081
  }
}
