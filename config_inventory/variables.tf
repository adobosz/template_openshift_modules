variable "vm_os_password"       { type = "string"  description = "Operating System Password for the Operating System User to access virtual machine"}
variable "vm_os_user"           { type = "string"  description = "Operating System user for the Operating System User to access virtual machine"}
variable "master_node_ip"       { type = "string"}
variable "master_node_hostname"           { type = "string"}
variable "etcd_node_hostname"             { type = "string"}
variable "compute_node_hostname"           { type = "string"}
variable "lb_node_hostname"             { type = "string"}
variable "enable_lb"             { type = "string"}
variable "vm_domain_name"           { type = "string"}
variable "infra_node_hostname"             { type = "string"}
variable "infra_node_ip"         { type = "string"}
variable "rh_user"              { type = "string" }
variable "rh_password"          { type = "string" }
variable "compute_node_enable_glusterfs"          { type = "string"}
