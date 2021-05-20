provider "aws"{
    version = "~> 2.0"
    region = "sa-east-1"
}

#para poder utilizar uma nova regiao
provider "aws"{
    alias = "us-east-2"
    version = "~> 2.0"
    region = "us-east-2"
}

##provisionamento de 3 instancias EC2 t2.micro com ubuntu free tier
resource "aws_instance" "dev" {
    count = 3
    ami = "ami-054a31f1b3bf90920"  
    instance_type = "t2.micro"
    key_name = "terraform-aws"
    tags = {
        Name = "dev${count.index}" ##utiliza o index do count, dessa forma cada maquina tera o nome 1, 2 ou 3
    }
    #vpc_security_group_ids = ["sg-08c51449b75e1b578"]
    vpc_security_group_ids = ["${aws_security_group.acesso-ssh.id}"] #busca o atributo id, usando referencia
}

#criar um bucket s3
resource "aws_s3_bucket" "dev4" {
  bucket = "rakiyamalabs-dev4"
  acl    = "private"

  tags = {
    Name = "rakiyamalabs-dev4"
    
  }
}

##provisionamento da instancia 4 que ira estar vinculado ao bucket s3
resource "aws_instance" "dev4" {
    
    ami = "ami-054a31f1b3bf90920"  
    instance_type = "t2.micro"
    key_name = "terraform-aws"
    tags = {
        Name = "dev4"
    }
    #vpc_security_group_ids = ["sg-08c51449b75e1b578"]
    vpc_security_group_ids = ["${aws_security_group.acesso-ssh.id}"] #busca o atributo id, usando referencia
    depends_on = [aws_s3_bucket.dev4] #estabelece a dependencia entre o bucket e a instancia 
      
    
}

##provisionamento da instancia 5
resource "aws_instance" "dev5" {
    
    #ami = "ami-054a31f1b3bf90920"  #declaracao manual da imagem
    ami = var.amis["sa-east-1"]
    instance_type = "t2.micro"
    #key_name = "terraform-aws" #declaracao manual
    key_name = var.key_name
    tags = {
        Name = "dev5"
    }    
    vpc_security_group_ids = ["${aws_security_group.acesso-ssh.id}"] #busca o atributo id, usando referencia
}

##provisionamento da instancia 6 em outra regiao, sera vinculado com um banco de dados
resource "aws_instance" "dev6" {
    provider = aws.us-east-2
    #ami = "ami-077e31c4939f6a2f3"  #declaracao manual da imagem
    ami = var.amis["us-east-2"] #utilizando variaveis, referenciando o atributo especifico
    instance_type = "t2.micro"
    #key_name = "terraform-aws" #declaracao manual
    key_name = var.key_name
    tags = {
        Name = "dev6"
    }    
    vpc_security_group_ids = ["${aws_security_group.acesso-ssh-us-east-2.id}"] #busca o atributo id, usando referencia do arquivo do security group
    depends_on = [aws_dynamodb_table.dynamodb-homologacao]
}

#criando um banco de dados dynamo db
resource "aws_dynamodb_table" "dynamodb-homologacao" {
  provider = "aws.us-east-2"
  name           = "GameScores"
  billing_mode   = "PAY_PER_REQUEST"  
  hash_key       = "UserId"
  range_key      = "GameTitle"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "GameTitle"
    type = "S"
  }

}

##provisionamento da instancia 7 em outra regiao, agora utilizando todas as variaveis 
resource "aws_instance" "dev7" {
    provider = aws.us-east-2
    #ami = "ami-077e31c4939f6a2f3"  #declaracao manual da imagem
    ami = "${var.amis["us-east-2"]}" #utilizando variaveis, referenciando o atributo especifico
    instance_type = "t2.micro"
    #key_name = "terraform-aws" #declaracao manual
    key_name = "${var.key_name}"
    tags = {
        Name = "dev7"
    }    
    vpc_security_group_ids = ["${aws_security_group.acesso-ssh-us-east-2.id}"] #busca o atributo id, usando referencia do arquivo do security group    
}