# Déploiement Azure Bastion + VM avec Terraform
## Qu'est-ce qu'Azure Bastion ?
Azure Bastion est une plateforme en tant que service (PaaS) entièrement managée par Microsoft. Elle permet de fournir un accès sécurisé, sans exposition de ports publics (RDP ou SSH) à vos machines virtuelles Azure, directement depuis le portail Azure ou via un tunnel local sécurisé (az network bastion tunnel). Cela élimine le besoin d’IP publiques sur les VMs et renforce significativement la posture de sécurité réseau..

Azure Bastion :

Est conçu et configuré pour résister aux attaques.
Fournit une connectivité RDP et SSH à vos applications Azure derrière le service Bastion.
