output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
  sensitive = true
}
output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config
  sensitive = true
}
output "ingress_ip"{
  value = "${azurerm_public_ip.nginx_ingress.ip_address}"
}
output "fqdn"{
  value = "${azurerm_public_ip.nginx_ingress.fqdn}"
}