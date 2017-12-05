resource "null_resource" "start_shopfront_backend" {

provisioner "local-exec" {
   command =  "kubctl apply -f kubernetes/shopfront-services.yml"
   }
}

