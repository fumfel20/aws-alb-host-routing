[project1]
project1_server ansible_host=${project1_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${ssh_key_path}

[project2]
project2_server ansible_host=${project2_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${ssh_key_path}
