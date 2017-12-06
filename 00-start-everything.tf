



####
## MYSQL
####
#create persisted volume for mysql
resource "kubernetes_persistent_volume" "mysql-volume" {
    metadata {
        name = "volume"
    }
    spec {
        capacity {
            storage = "2Gi"
        }
        access_modes = ["ReadWriteMany"]
        persistent_volume_source {
            host_path  {
                path = "/var/lib/mysql"
            }
        }
    }
}

#create mysql pod with claim of the persisted volume
resource "kubernetes_pod" "mysql" {
  metadata {
    name = "mysql-pod"
  }

  spec {
    container {
      image = "mysql:5.6"
      name  = "product_catalogue_mysql"      
    }
    volume {
      name = "${kubernetes_persistent_volume.mysql-volume.metadata.0.name}"
    }
  }
}

#expose mysql service port 3306
resource "kubernetes_service" "mysql-services" {
  metadata {
    name = "mysql-services"
  }
  spec {
    selector {
      App = "${kubernetes_pod.mysql.metadata.0.labels.App}"
    }
    port {
      port = 3306
      target_port = 3306
    }
    type = "LoadBalancer"
  }
}

####
## SHOPFRONT
####
#create pod for shopfront with replica = 1 since this is only for local dev machine
resource "kubernetes_pod" "shopfront" {
  metadata {
    name = "shopfront"
    labels {
      App = "shopfront"
    }
  }

  spec {
      container {
        image = "mhadian/shopfront:1.0"
        name  = "nginxhttps"

        port {
          container_port = 8010
        }

        resources {
          limits {
            cpu    = "0.5"
            memory = "512Mi"
          }
          requests {
            cpu    = "250m"
            memory = "50Mi"
          }
        }
      }
    
  } 
}

#expose the shopfront pod service port 8010
resource "kubernetes_service" "shopfront-services" {
  metadata {
    name = "shopfront-servicesn"
  }
  spec {
    selector {
      App = "${kubernetes_pod.shopfront.metadata.0.labels.App}"
    }
    port {
      port = 8010
      target_port = 8010
    }
    type = "NodePort"
  }
}

####
## PRODUCT CATALOGUE
####
#create pod for product catalogue with replica = 1 since this is only for local dev machine
resource "kubernetes_pod" "product-calatalogue" {
  metadata {
    name = "product-calatalogue"
    labels {
      App = "product-calatalogue"
    }
  }

  spec {
      container {
        image = "mhadian/productcatalogue:1.0"
        name  = "productcatalogue"

        port {
          container_port = 8020
        }
        resources {
          limits {
            cpu    = "0.5"
            memory = "512Mi"
          }
          requests {
            cpu    = "250m"
            memory = "50Mi"
          }
        }
      }
  } 
}

#expose the product catalogue pod service port 8020
resource "kubernetes_service" "product-calatalogue-service" {
  metadata {
    name = "product-calatalogue-service"
  }
  spec {
    selector {
      App = "${kubernetes_pod.product-calatalogue.metadata.0.labels.App}"
    }
    port {
      port = 8020
      target_port = 8020
    }
    type = "NodePort"
  }
}

####
## STOCK MANAGER
####
#create pod for stock manager with replica = 1 since this is only for local dev machine
resource "kubernetes_pod" "stock-manager" {
  metadata {
    name = "stock-manager"
    labels {
      App = "stock-manager"
    }
  }

  spec {
      container {
        image = "mhadian/stockmanager:1.0"
        name  = "stock_manager"

        port {
          container_port = 8030
        }

        resources {
          limits {
            cpu    = "0.5"
            memory = "512Mi"
          }
          requests {
            cpu    = "250m"
            memory = "50Mi"
          }
        }
      }
    
  } 
}

#expose the stock manager pod service port 8030
resource "kubernetes_service" "stock-manager-service" {
  metadata {
    name = "stock-manager-service"
  }
  spec {
    selector {
      App = "${kubernetes_pod.stock-manager.metadata.0.labels.App}"
    }
    port {
      port = 8030
      target_port = 8030
    }
    type = "NodePort"
  }
}
