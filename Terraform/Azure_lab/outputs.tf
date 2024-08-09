output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
output "vnet_id" {
  value = azurerm_virtual_network.vnet_example.id
}
output "subnet_ids" {
  value = azurerm_subnet.public.id
}
output "vm_ids" {
  value = azurerm_virtual_machine.main.id
}