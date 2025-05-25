# Déploiement Azure Bastion + VM avec Terraform
## Qu'est-ce qu'Azure Bastion ?
Azure Bastion est un service PaaS entièrement managé qui permet un accès sécurisé et privé à vos machines virtuelles Azure, sans exposer d’adresse IP publique ni ouvrir les ports RDP/SSH.

Il remplace l’usage traditionnel d’une Jump Box — une machine intermédiaire avec un système d’exploitation serveur utilisée pour accéder au réseau interne — en simplifiant la sécurité et la gestion des connexions.

Azure Bastion permet l’accès :
- via le **portail Azure** (navigateur web),
- avec **az network bastion tunnel** (tunnel SSH/RDP),
- ou avec **az network bastion ssh** (connexion SSH directe via CLI).
