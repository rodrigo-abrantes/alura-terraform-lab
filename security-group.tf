##provisionamento de regra no security group para permitir conexao ssh
resource "aws_security_group" "acesso-ssh" {
  name        = "acesso-ssh"
  description = "Permitir conexao ssh"
  #vpc_id      = aws_vpc.main.id

  ingress {    
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    #cidr_blocks      = ["189.100.70.145/32"]    #declaracao manual
    cidr_blocks = var.cdirs_acesso_remoto
  }
  tags = {
    Name = "permite_ssh"
  }  
}
##key_name eh o par de chaves ssh para conexao 
##gerei uma chave local na vm que ai nao precisarei criar uma para cada maquina
##mandei achave na aws e coloquei o nome


#resource group para outra regiao
resource "aws_security_group" "acesso-ssh-us-east-2" {
  provider = "aws.us-east-2"
  name        = "acesso-ssh"
  description = "Permitir conexao ssh"  

  ingress {    
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    #cidr_blocks      = ["189.100.70.145/32"]    #declaracao manual
    cidr_blocks = var.cdirs_acesso_remoto #usando variaveis
  }
  tags = {
    Name = "permite_ssh"
  }  
}