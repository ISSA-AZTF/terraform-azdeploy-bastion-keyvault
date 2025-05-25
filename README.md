# Déploiement Azure Bastion + VM avec Terraform
## Qu'est-ce qu'Azure Bastion ?
Azure Bastion est un service PaaS entièrement managé qui permet un accès sécurisé et privé à vos machines virtuelles Azure, sans exposer d’adresse IP publique ni ouvrir les ports RDP/SSH.

Il remplace l’usage traditionnel d’une Jump Box — une machine intermédiaire avec un système d’exploitation serveur utilisée pour accéder au réseau interne — en simplifiant la sécurité et la gestion des connexions.

Azure Bastion permet l’accès :
- depuis le **portail Azure** via l’interface web,,
- en établissant un tunnel avec **az network bastion tunnel**,
- ou en ligne de commande directement avec **az network bastion ssh**.
