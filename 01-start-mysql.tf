resource "null_resource" "start_mysql" {

provisioner "local-exec" {
   command =  "kubectl apply -f kubernetes/mysql-volumes.yaml"
   }
provisioner "local-exec" {
   command =  "kubctl apply -f kubernetes/shopfront-mysql.yml"
   }
}

