resource "kubectl_manifest" "storage_class" {
  yaml_body = file("${path.module}/storageclass.yaml")
}
