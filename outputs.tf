#Gera um output ao fim da execucao 


output "ip_dev5" {
    value = "${aws_instance.dev5.public_ip}"  
}

