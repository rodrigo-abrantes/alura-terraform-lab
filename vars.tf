#criacao de uma variavel do tipo chave e valor, json comum mesmo
variable "amis" {
    type = map(string)

    default = {
        "sa-east-1" = "ami-054a31f1b3bf90920"
        "us-east-2" = "ami-077e31c4939f6a2f3"
    }
}

#criacao de uma variavel para os cdirs de acesso remoto nas instancias
variable "cdirs_acesso_remoto" {
    type = list(string)

    default = ["189.100.70.145/32"]

}

#variavel para colocar o keyname
variable "key_name" {
    type = string
    default = "terraform-aws"
  
}
