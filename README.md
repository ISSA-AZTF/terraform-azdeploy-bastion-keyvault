# Déploiement Azure Bastion + VM avec Terraform
## Qu'est-ce qu'Azure Bastion ?
Azure Bastion est un service PaaS entièrement managé qui permet un accès sécurisé et privé à vos machines virtuelles Azure, sans exposer d’adresse IP publique ni ouvrir les ports RDP/SSH.

Il remplace l’usage traditionnel d’une Jump Box — une machine intermédiaire avec un système d’exploitation serveur utilisée pour accéder au réseau interne — en offrant une alternative plus simple, plus sécurisée et native à Azure.

Plusieurs modes de connexion sont pris en charge :

- Interface graphique via le **portail Azure**,
- Ligne de commande avec **az network bastion ssh**,
- Tunnel local avec **az network bastion tunnel**.

## Architecture déployée
Ce step-by-step déploie une infrastructure réseau sécurisée avec Azure Bastion, une VM Linux et un Key Vault pour stocker la clé SSH.
📷 Aperçu Terraform Visual :
Ce schéma a été généré via l'outil Terraform Visual, permettant de visualiser le graphe des ressources.
![Terraform plan](Pictures/All_resources.png)