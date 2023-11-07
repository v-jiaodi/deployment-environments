output "URI" {
  value = "https://${azurerm_linux_web_app.webpython[0].default_hostname}" 
}

output "IDENTITY_PRINCIPAL_ID" {
  value     = length(azurerm_linux_web_app.webpython[0].identity) == 0 ? "" : azurerm_linux_web_app.webpython[0].identity.0.principal_id
  sensitive = true
}