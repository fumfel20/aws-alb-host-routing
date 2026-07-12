output "alb_dns_name" {
  value       = aws_lb.main.dns_name
  description = "The DNS name of the Application Load Balancer"
}

output "project1_instance_ip" {
  value       = aws_instance.project1.public_ip
  description = "Public IP address of the Project 1 EC2 instance"
}

output "project2_instance_ip" {
  value       = aws_instance.project2.public_ip
  description = "Public IP address of the Project 2 EC2 instance"
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.ini.tpl", {
    project1_ip  = aws_instance.project1.public_ip
    project2_ip  = aws_instance.project2.public_ip
    ssh_key_path = "{{ inventory_dir }}/../terraform/${var.ssh_key_path}"
  })
  filename = "${path.module}/../ansible/inventory.ini"
}
