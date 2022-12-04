#  Challenger 

Este repositório tem como objetivo construir uma infraestrutura na aws com terraform
provisionar o servidor com ansible,dockerizar e deployar uma página HTML estática servida pelo nginx com docker
deployar uma aplcação python(que puxa as métricas de memória e CPU da máquina e mostra a saída em formtado JSON
servida pelo nginx com docker e construir uma pipeline githubactions para o deploy automatizado do código.

##  Diagrama do projeto

![Project Diagram](https://user-images.githubusercontent.com/90812723/205381049-a00c3da4-cb71-4c19-8282-2a81b60f5c33.png)


## Terraform

Deploy da infraestrutura com o servidor dentro da AWS(provider.tf e ec2.tf)

```
terraform init
terraform plan
terraform apply -auto-approve
```

## Ansible

Ansible é executado em tempo de execução da máquina fazendo o download dos repositórios necessários para o deploy(ansible.yaml).

## Conteiners 

Será feito o deploy de 3 containers dentro do servidor(ec2),container do nginx com index.html
container do nginx apontado para o container da aplicação python.

## Pipeline

Todo push feito do repo para a branch que for específicada na pipeline,será deployada com o novo código.

Para acessar a página estática HTML > http://$"IPDAEC2":81
Para acessar a aplicação python > http://$"IPDAEC2":80
