resource "kubernetes_deployment" "image_classifier" {
  metadata {
    name      = "image-classifier"
    namespace = "default"

    labels = {
      app = "image-classifier"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "image-classifier"
      }
    }

    template {
      metadata {
        labels = {
          app = "image-classifier"
        }
      }

      spec {
        container {
          name  = "tf-serving"
          image = "tensorflow/serving"
          args  = ["--model_name=$(MODEL_NAME)", "--model_base_path=$(MODEL_PATH)"]

          port {
            name           = "http"
            container_port = 8501
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 8500
            protocol       = "TCP"
          }

          env_from {
            config_map_ref {
              name = "tfserving-configs"
            }
          }

          resources {
            requests = {
              cpu = "3"

              memory = "4Gi"
            }
          }

          readiness_probe {
            tcp_socket {
              port = "8500"
            }

            initial_delay_seconds = 10
            period_seconds        = 5
            failure_threshold     = 10
          }

          image_pull_policy = "IfNotPresent"
        }
      }
    }
  }
}

