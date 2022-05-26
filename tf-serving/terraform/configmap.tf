resource "kubernetes_config_map" "tfserving_configs" {
  metadata {
    name = "tfserving-configs"
  }

  data = {
    MODEL_NAME = "image_classifier"

    MODEL_PATH = "gs://your-bucket-name/resnet_101"
  }
}

