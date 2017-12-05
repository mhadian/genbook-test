resource "null_resource" "start_minikube" {

provisioner "local-exec" {
   command =  "minikube start --cpus 2 --memory 4096"
   }
}

