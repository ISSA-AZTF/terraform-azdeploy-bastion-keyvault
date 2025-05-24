
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
output "bastion_pip" {
  value = azurerm_public_ip.pip.ip_address
}
output "vm_id" {
  value = azurerm_linux_virtual_machine.linux_vm.id
}
output "key_vault_id" {
  value = azurerm_key_vault.key_vault[0].id
}
output "secret_key" {
  value     = data.azurerm_key_vault_secret.retreive_key
  sensitive = true
}
