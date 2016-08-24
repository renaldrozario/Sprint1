provider "softlayer" {
	username = ""
	api_key = ""
}
resource "softlayer_virtual_guest" "myveryownserver1" {
    name = "hostname"
    domain = "cfscos2.com"
    #image = "CENTOS_6_64"
    block_device_template_group_gid = "imagename"
    region = "che01"
    hourly_billing = true
    local_disk = false
    cpu = cpucount
    ram = ramsize
    public_network_speed = 10
}
output "myserver_ip" {
  value = "${softlayer_virtual_guest.myveryownserver1.ipv4_address}"
}
