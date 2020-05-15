resource "null_resource" "config_inventory_file" {
  
connection {
    type = "ssh"
    user = "${var.vm_os_user}"
    password =  "${var.vm_os_password}"
    host = "${var.master_node_ip}"   
  }

  provisioner "remote-exec" {
    inline = [
      "echo -n ${var.master_node_hostname} > /tmp/old_master.txt",
      "echo -n ${var.etcd_node_hostname} > /tmp/old_etcd.txt",
      "echo -n ${var.compute_node_hostname} > /tmp/old_compute.txt",
      "echo -n ${var.lb_node_hostname} > /tmp/old_lb.txt",
      "echo -n ${var.infra_node_hostname} > /tmp/old_infra.txt"
    ]
  }

  provisioner "file" {
    source = "${path.module}/scripts/config_inventory.sh"
    destination = "/tmp/config_inventory.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "chmod 755 /tmp/config_inventory.sh",
      "bash -c '/tmp/config_inventory.sh ${var.master_node_hostname} ${var.etcd_node_hostname} ${var.compute_node_hostname} ${var.lb_node_hostname} ${var.infra_node_hostname} ${var.infra_node_ip} ${var.rh_user} ${var.rh_password} ${var.vm_domain_name} ${var.enable_lb} ${var.compute_node_enable_glusterfs} ${var.vm_os_password}'"
    ]
  }
}

resource "null_resource" "finish_config_inventory" {
  provisioner "local-exec" {
    command = "echo 'Configuring inventory file finished successfully.'" #${var.vm_ipv4_address_list}.'"
  }
}
