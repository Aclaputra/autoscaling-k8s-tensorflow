resource "kubernetes_service" "image_classifier" {
  metadata {
    name      = "image-classifier"
    namespace = "default"

    labels = {
      app = "image-classifier"
    }
  }

  spec {
    port {
      name     = "tf-serving-grpc"
      protocol = "TCP"
      port     = 8500
    }

    port {
      name     = "tf-serving-http"
      protocol = "TCP"
      port     = 8501
    }

    selector = {
      app = "image-classifier"
    }

    type = "LoadBalancer"
  }
}

