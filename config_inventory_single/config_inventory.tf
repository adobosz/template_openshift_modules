resource "null_resource" "master_dependsOn" {
  provisioner "local-exec" {
# Hack to force dependencies to work correctly. Must use the dependsOn var somewhere in the code for dependencies to work. Contain value which comes from previous module.
	  command = "echo The dependsOn output for hostfile module is ${var.dependsOn}"
  }
}
resource "null_resource" "config_inventory_file" {
  depends_on = ["null_resource.master_dependsOn"]

  connection {
    type = "ssh"
    user = "${var.vm_os_user}"
    password =  "${var.vm_os_password}"
    private_key = "${var.private_key}"
    host = "${var.single_node_ipv4_address}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${length(var.bastion_private_key) > 0 ? base64decode(var.bastion_private_key) : var.bastion_private_key}"
    bastion_port        = "${var.bastion_port}"
    bastion_host_key    = "${var.bastion_host_key}"
    bastion_password    = "${var.bastion_password}"      
  }
  provisioner "file" {
    source = "${path.module}/scripts/config_inventory.sh"
    destination = "/tmp/config_inventory.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "chmod 755 /tmp/config_inventory.sh",
      "bash -c '/tmp/config_inventory.sh ${var.single_node_hostname} ${var.single_node_ipv4_address} ${var.vm_domain_name} ${var.rh_user} ${var.rh_password}'"
    ]
  }
}

resource "null_resource" "finish_config_inventory" {
  depends_on = ["null_resource.config_inventory_file"]
  provisioner "local-exec" {
    command = "echo 'Configuring inventory file finished successfully.'" #${var.vm_ipv4_address_list}.'"
  }
}
