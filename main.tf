# ********************************************
# Azure Bastion hôte et ses dépendances
# ********************************************

# Nombre aléatoire
resource "random_id" "suffix" {
  byte_length = 2
}

# resource group 
resource "azurerm_resource_group" "rg" {
  name     = format("%s-%s-%s-%s", title(var.env), title(var.host), lower(var.suffix), random_id.suffix.hex)
  location = var.location
}
# virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = join("-", [var.env, var.host, var.vnet_name])
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = merge({ Resourcetype = format("%s", "vnet") }, var.global_tags)
}

# Azure bastion host sous réseau
resource "azurerm_subnet" "subnet" {
  name                 = local.bastion_subnet
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = local.subnet_cidr # start from /26
}

# Adresse IP publique
resource "azurerm_public_ip" "pip" {
  name                = format("%s-%s-%s", title(var.env), title(var.host), "pip")
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = var.pip_allocation
  sku                 = var.pip_sku
}

# Azure bastion hôte
resource "azurerm_bastion_host" "Bastion_host" {
  name                = format("%s-%s-%s", title(var.env), title(var.host), "Bastion")
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.bastion_sku
  tunneling_enabled   = true
  scale_units         = 3 # 150 connexions simultannées RDP/SSH 
  tags                = merge({ Resourcetype = format("%s", "Bastion") }, var.global_tags)

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet.id
    public_ip_address_id = azurerm_public_ip.pip.id

  }
}

# ********************************************
# Machine virtuelle et ses dépendances
# ********************************************

# Sous réseau de la VM
resource "azurerm_subnet" "vm_subnet" {
  name                 = "${var.vm_prefix}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.vm_subnet
}

# Interface Réseau
resource "azurerm_network_interface" "vm_nic" {
  name                = "${var.nic_prefix}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = var.ip_conf[0]
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = var.ip_conf[1]
  }
}

# Machine Virtuelle
resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]
  tags = merge({ Resourcetype = format("%s", "ubuntu-vm") }, var.global_tags)

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("${path.module}/id_rsa.pub")
  }

  os_disk {
    caching              = var.caching
    storage_account_type = var.sa_replication_type
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.os_version
  }
}

# ********************************************
# Key vault
# ********************************************


data "azurerm_client_config" "current" {}

# key vault
resource "azurerm_key_vault" "key_vault" {
  count                       = var.create_key_vault && element(var.key_vault_sku, 0) == "standard" ? 1 : 0
  name                        = "${var.key_vault_name}-${random_id.suffix.hex}"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true

  sku_name = var.key_vault_sku[count.index]

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "Set",
      "List",
      "Delete",
      "Recover"
    ]
  }
}

# Création d'un secret stockant la clé privée 
resource "azurerm_key_vault_secret" "key_secret" {
  name         = local.key_vault_secret
  value        = file("${path.module}/id_rsa")
  key_vault_id = azurerm_key_vault.key_vault[0].id
}

# Data source récupérant la clé privée (secret) et garantit un accès centralisé via key vault
data "azurerm_key_vault_secret" "retreive_key" {
  name         = azurerm_key_vault_secret.key_secret.name
  key_vault_id = azurerm_key_vault.key_vault[0].id
  depends_on   = [azurerm_key_vault_secret.key_secret]
}


