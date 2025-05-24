
variable "location" {
  type        = string
  default     = "west europe"
  description = "Localisation Azure des ressources"
}
variable "env" {
  type        = string
  default     = "Staging"
  description = "environnement de déploiement de la ressource"
}
variable "host" {
  type        = string
  default     = "Bastion"
  description = " Identifiant de certaines ressources "
}
variable "suffix" {
  type        = string
  default     = "rg"
  description = "Suffixe pour le nom du groupe de ressources "
}
variable "vnet_name" {
  type        = string
  default     = "vnet"
  description = "Suffixe pour le nom du réseau virtuel"
}
locals {
  bastion_subnet = "AzureBastionSubnet"
  # Nom obligatoire du subnet hébergeant la ressource Bastion
}
variable "bastion_sku" {
  type        = string
  default     = "Standard"
  description = "Bastion SKU"
}
variable "vm_prefix" {
  type    = string
  default = "vm"
}
variable "vnet_address_space" {
  type        = list(string)
  default     = ["192.168.1.0/24"]
  description = "la plage d'adresse ip du réseau virtuel"
}
variable "vm_subnet" {
  type        = list(string)
  default     = ["192.168.1.0/25"]
  description = "Sous réseau hostant la machine virtuelle "
}
variable "nic_prefix" {
  type        = string
  default     = "staging_vm"
  description = "Préfix du nom de l'interface réseau"
}
variable "ip_conf" {
  type        = list(string)
  default     = ["testconfiguration1", "Dynamic"]
  description = "Config IP de l'interface réseau "
}
variable "pip_sku" {
  type        = string
  default     = "Standard"
  description = "Référence (SKU) de l'ip publique "
}
variable "pip_allocation" {
  type        = string
  default     = "Static"
  description = "Il s'agit de l'allocation static d'une adresse ip publique"
}
variable "vm_name" {
  type        = string
  default     = "linux-machine"
  description = "Nom de la machine virtuelle"
}
variable "vm_size" {
  type        = string
  default     = "Standard_B1s"
  description = "SKU de la Machine virtuelle "
}
variable "admin_username" {
  type        = string
  default     = "testadmin"
  description = "Nom administrateur de la VM"
}
variable "global_tags" {
  type = map(string)
  default = {
    "environment" = "staging"
    "department"  = "IT"
  }
  description = " Map de tags globale appliquées à certaines ressources"
}
locals {
  subnet_calcul = cidrsubnet("192.168.1.0/24", 3, 6)
  # Calcul de la plage CIDR pour le sous-réseau Azure Bastion
}
locals {
  subnet_cidr = [local.subnet_calcul]
}
variable "caching" {
  type        = string
  default     = "ReadWrite"
  description = "type de mise en cache sur le disque temporaire "
}
variable "sa_replication_type" {
  type        = string
  default     = "Standard_LRS"
  description = "type de replication de données"
}
variable "publisher" {
  type        = string
  default     = "Canonical"
  description = "éditeur officiel de l'image ubuntu"
}
variable "offer" {
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
  description = "il s'agit de la famille d'image ubuntu"
}
variable "sku" {
  type        = string
  default     = "22_04-lts"
  description = "LTS (SKU) de l'image"
}
variable "os_version" {
  type        = string
  default     = "latest"
  description = "Version exacte de l'image"
}
variable "create_key_vault" {
  type        = bool
  default     = true
  description = "Indique si la ressource key vault doit être crée ou non "
}

variable "key_vault_name" {
  type        = string
  default     = "sshkeyvault"
  description = "Préfix du nom de la ressource key vault"
}
variable "key_vault_sku" {
  type        = list(string)
  default     = ["standard", "premium"]
  description = "Nom de la référence (SKU) pour le key vault"
}
locals {
  key_vault_secret = "ubuntu-key"
  # Nom du secret stockant la clé privée ssh
}

