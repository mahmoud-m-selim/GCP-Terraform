
data "template_file" "startup_script" {
  template = <<-EOF
  sudo apt-get update -y
  sudo apt-get install -y tinyproxy
  echo "Allow localhost"| tee -a /etc/tinyproxy/tinyproxy.conf
  systemctl restart tinyproxy
  EOF
}


resource "google_compute_instance" "bastion" {
  name         = "bastion"
  machine_type = "e2-medium"
  zone         = "us-west2-a"
  tags         = ["bastion_host"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network    = module.network.vpc_name
    subnetwork = module.network.public_subnet_name

  }

  metadata_startup_script = data.template_file.startup_script.rendered

}