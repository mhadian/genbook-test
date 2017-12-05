resource "null_resource" "start_shopfront_frontend" {

provisioner "local-exec" {
   command =  "kubctl apply -f ../kubernetes/shopfront-services.yml"
   }
}

