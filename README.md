# 🖥️ Smart IT Agent V9
## Système intelligent de supervision et de remédiation informatique

**Smart IT Agent V9** est un projet de supervision informatique développé en Java et PowerShell.

Il permet de centraliser la surveillance de plusieurs machines Windows, de détecter les anomalies, de générer des journaux et des rapports, d'envoyer des notifications et de réaliser des actions de remédiation automatique.

### 🎯 Objectifs du projet

- Superviser les ressources CPU, RAM et disque.
- Surveiller les services Windows.
- Superviser plusieurs machines à distance avec WinRM.
- Détecter et enregistrer les incidents.
- Centraliser les informations dans un tableau de bord.
- Générer des rapports de supervision.
- Envoyer des notifications automatiques.
- Automatiser certaines actions correctives.

---

# 📸 Captures du projet — Smart IT Agent V9

Cette section présente les **15 étapes principales du projet**, depuis son architecture générale jusqu'à la supervision à distance, la gestion des incidents et la remédiation automatique.

---

## 🖥️ 1. SMART IT AGENT V9 — Présentation générale

Cette première capture présente l'architecture générale du projet Smart IT Agent V9.

Le système repose sur trois fonctionnalités principales :

- **Supervision :** surveillance des ressources et des services Windows.
- **Détection :** identification des anomalies et des incidents informatiques.
- **Remédiation :** exécution d'actions correctives pour certains problèmes détectés.

L'objectif est de développer une solution permettant de centraliser la supervision informatique et de réduire les interventions manuelles.

![SMART IT AGENT V9](screenshots/SMART%20IT%20AGENT%20V9.jpg)

---

## 💻 2. Développement du Smart IT Agent en Java

Cette capture présente l'environnement de développement de l'agent principal.

Le projet utilise :

- **Java JDK 21 :** langage et environnement d'exécution de l'agent.
- **Visual Studio Code :** éditeur utilisé pour développer le programme.
- **PowerShell :** outil permettant d'exécuter des commandes système Windows.

L'agent Java assure la collecte, le traitement et la centralisation des informations provenant des machines supervisées.

Il analyse notamment l'utilisation du processeur, de la mémoire et du disque, ainsi que l'état des services Windows.

![Développement du Smart IT Agent en Java](screenshots/Développement%20du%20Smart%20IT%20Agent%20en%20Java.png)

---

## ⚙️ 3. Développement du script PowerShell de collecte

Cette étape présente le développement du script PowerShell chargé de récupérer les informations système.

Le script collecte plusieurs indicateurs :

- **CPU :** pourcentage d'utilisation du processeur.
- **RAM :** pourcentage de mémoire utilisée.
- **Disque :** espace utilisé sur le disque système.
- **Services Windows :** état des services surveillés.

Le script peut être exécuté localement ou à distance via WinRM.

Les données récupérées sont ensuite exploitées par Smart IT Agent pour assurer la supervision.

![Développement du script PowerShell de collecte](screenshots/Développement%20du%20script%20PowerShell%20de%20collecte%20des%20données%20système.png)

---

## 🌐 4. Vérification de la Connectivité Réseau et Configuration IP

Cette capture présente la configuration réseau de la machine virtuelle PC1.

Avant de mettre en place la supervision à distance, il est nécessaire de vérifier la communication entre les différentes machines.

Les opérations réalisées comprennent :

- Vérification de l'adresse IPv4.
- Vérification de la configuration réseau.
- Identification de la passerelle.
- Exécution de tests de connectivité avec la commande `ping`.

Cette étape permet de préparer la communication entre Windows 11 et les machines Windows 10 distantes.

![Vérification de la Connectivité Réseau et Configuration IP](screenshots/Vérification%20de%20la%20Connectivité%20Réseau%20et%20Configuration%20IP%20%28PC1%29%20%282%29.jpg)

---

## 🔐 5. Configuration WinRM et test PowerShell distant

Cette étape présente la configuration de **Windows Remote Management (WinRM)**.

WinRM est un service Windows permettant l'administration et l'exécution de commandes à distance.

Dans ce projet, WinRM permet à Smart IT Agent de communiquer avec les machines supervisées.

### Fonctionnement

1. Le poste principal Windows 11 initialise une connexion distante.
2. WinRM permet l'exécution des commandes PowerShell.
3. Les informations système sont récupérées.
4. Les résultats sont transmis au poste principal.

Cette architecture permet de superviser les machines Windows 10 sans installer Java sur chaque poste client.

![Configuration WinRM et test PowerShell distant](screenshots/Configuration%20WinRM%20et%20test%20PowerShell%20distant.png)

---

## ✅ 6. Configuration WinRM et Tests PowerShell Réussis

Cette capture présente les tests de communication entre les machines.

L'environnement comprend :

- **Windows 11 :** poste principal hébergeant Smart IT Agent.
- **PC1 :** machine Windows 10 distante.
- **PC2 :** deuxième machine Windows 10 distante.

Les vérifications portent sur :

- La connectivité réseau.
- L'accessibilité de WinRM.
- Le port TCP 5985 utilisé par WinRM HTTP.
- L'authentification distante.
- L'exécution des commandes PowerShell.

Ces tests permettent de valider les prérequis nécessaires à la supervision distante.

![Configuration WinRM et Tests PowerShell Réussis](screenshots/Configuration%20WinRM%20et%20Tests%20PowerShell%20Réussis.png)

---

## ▶️ 7. Exécution Smart IT Agent V9 en PowerShell

Cette étape présente le lancement de Smart IT Agent V9.

L'agent Java est exécuté depuis PowerShell sur la machine principale Windows 11.

Le programme réalise des cycles de supervision afin de récupérer régulièrement les informations système.

### Machines supervisées

| Machine | Système | Fonction |
|---|---|---|
| Windows 11 | Windows 11 | Agent principal |
| PC1 | Windows 10 | Machine distante |
| PC2 | Windows 10 | Machine distante |

Le système centralise les données collectées et permet d'identifier les anomalies détectées pendant l'exécution.

![Exécution Smart IT Agent V9 en PowerShell](screenshots/Exécution%20Smart%20IT%20Agent%20V9%20en%20PowerShell.png)

---

## 📊 8. Journal de monitoring en temps réel

Cette capture présente le fichier `monitoring.log`.

Ce journal permet de conserver un historique des informations collectées pendant les cycles de supervision.

Les informations enregistrées comprennent :

- La date et l'heure des mesures.
- Le pourcentage d'utilisation du CPU.
- Le pourcentage d'utilisation de la RAM.
- L'utilisation du disque.
- L'état des services Windows surveillés.

L'historisation des mesures facilite l'analyse des performances et permet de consulter l'évolution de l'état des machines.

![Journal de monitoring en temps réel](screenshots/Journal%20de%20monitoring%20en%20temps%20réel.png)

---

## 🚨 9. Journal des incidents Smart IT Agent

Cette étape présente le journal `incidents.log`.

Ce fichier permet d'enregistrer les anomalies détectées pendant la supervision.

Les événements peuvent notamment être classés selon leur nature :

- **CRITICAL :** incident critique nécessitant une attention particulière.
- **ALERTE :** anomalie ou dépassement d'un seuil de surveillance.
- **RECOVERY :** retour à un état normal après un incident.

Le journal permet d'identifier les problèmes rencontrés et de conserver une trace des événements.

Il facilite également le diagnostic et le suivi des incidents informatiques.

![Journal des incidents Smart IT Agent](screenshots/Journal%20des%20incidents%20Smart%20IT%20Agent.png)

---

## 📈 10. Tableau de Bord de Supervision Globale du Parc Informatique

Cette capture présente le tableau de bord principal du projet.

L'interface permet de visualiser de manière centralisée l'état des trois machines supervisées.

### Informations présentées

- **CPU :** utilisation du processeur.
- **RAM :** consommation de mémoire.
- **Disque :** utilisation du stockage.
- **Services Windows :** état des services surveillés.
- **Incidents :** anomalies et alertes détectées.

Le tableau de bord facilite l'identification des problèmes et offre une vue globale de l'état du parc informatique.

Cette interface constitue un élément central de Smart IT Agent V9.

![Tableau de Bord de Supervision Globale du Parc Informatique](screenshots/Tableau%20de%20Bord%20de%20Supervision%20Globale%20du%20Parc%20Informatique%20%28Smart%20IT%29.jpg)

---

## ❌ 11. Erreur de Connexion et d’Accès aux Données de Supervision

Cette étape présente un exemple d'incident de communication avec la machine distante PC1.

Lorsqu'une connexion distante échoue, Smart IT Agent ne peut plus récupérer les informations système de la machine concernée.

Les causes possibles comprennent :

- Une interruption de la connexion réseau.
- Un problème de configuration WinRM.
- Une erreur d'authentification.
- Une machine distante indisponible.
- Un problème d'accès aux ressources système.

Le tableau de bord permet de signaler l'erreur et de présenter des informations utiles au diagnostic.

Cette fonctionnalité facilite l'identification des problèmes de communication.

![Erreur de Connexion et d’Accès aux Données de Supervision](screenshots/Erreur%20de%20Connexion%20et%20d%E2%80%99Acc%C3%A8s%20aux%20Donn%C3%A9es%20de%20Supervision%20%28PC1%29.jpg)

---

## 📧 12. Alerte Smart IT et notification automatique

Cette capture présente le système de notification automatique.

Lorsqu'un incident est détecté sur une machine supervisée, Smart IT Agent peut envoyer une notification par email.

### Informations de notification

- Nom de la machine concernée.
- Adresse IP.
- Date et heure de l'incident.
- Description de l'anomalie.
- Informations utiles au diagnostic.

L'objectif est d'informer rapidement l'administrateur informatique afin de faciliter la prise en charge des incidents.

Cette fonctionnalité contribue à améliorer la réactivité de la supervision.

![Alerte Smart IT et notification automatique](screenshots/Alerte%20Smart%20IT%20et%20notification%20automatique.png)

---

## 🔧 13. Supervision et Auto-Remédiation du Service Spooler

Cette étape présente la supervision et la remédiation du service Windows **Spooler** sur PC1.

Le service Spooler est responsable de la gestion des travaux d'impression sous Windows.

### Scénario de remédiation

1. Smart IT Agent surveille l'état du service Spooler.
2. Le système détecte un arrêt du service.
3. L'incident est identifié et enregistré.
4. L'agent déclenche une tentative de redémarrage.
5. Une nouvelle vérification permet de contrôler l'état du service.
6. Le journal de remédiation confirme le retour à l'état **RUNNING**.

Cette fonctionnalité illustre la capacité du projet à automatiser certaines interventions informatiques.

Elle vise à réduire le temps de résolution des incidents répétitifs.

![Supervision et Auto-Remédiation du Service Spooler](screenshots/Supervision%20et%20Auto-Rem%C3%A9diation%20du%20Service%20Spooler%20-%20PC1.jpg)

---

## 📄 14. Rapport de supervision informatique

Cette capture présente le système de génération de rapports.

Smart IT Agent permet de produire des rapports à partir des informations collectées pendant la supervision.

### Contenu du rapport

- Identification des machines supervisées.
- Informations sur les ressources système.
- Utilisation du CPU.
- Consommation de la RAM.
- Utilisation du disque.
- État des services Windows.
- Incidents détectés.

Ces rapports permettent de conserver une synthèse des performances et de faciliter le suivi de l'infrastructure informatique.

Ils constituent également un support utile pour l'analyse et la documentation technique.

![Rapport de supervision informatique](screenshots/Rapport%20de%20supervision%20informatique.png)

---

## 📊 15. Tableau de bord des journaux système

Cette dernière capture présente le tableau de bord dédié à la consultation des journaux système.

L'interface permet de consulter les informations enregistrées pendant les opérations de supervision.

Elle facilite :

- La consultation des événements système.
- L'analyse des incidents.
- Le suivi des alertes.
- L'identification des anomalies.
- La consultation des informations historiques.

Ce tableau de bord complète la supervision en offrant une interface dédiée à l'analyse des événements.

![Tableau de bord des journaux système](screenshots/Tableau%20de%20bord%20des%20journaux%20syst%C3%A8me.png)

---

# 🏗️ Architecture technique du projet

L'architecture de Smart IT Agent V9 repose sur un poste principal Windows 11 et deux machines Windows 10 distantes.

### Poste principal — Windows 11

Il héberge :

- L'agent principal développé en Java.
- Les scripts de collecte PowerShell.
- Le système de supervision.
- Les journaux de monitoring et d'incidents.
- Les tableaux de bord.
- Le système de génération de rapports.
- Le mécanisme de notification.
- Les fonctions de remédiation.

### Machines distantes — PC1 et PC2

Les deux machines Windows 10 sont supervisées à distance grâce à WinRM.

Elles fournissent les informations système nécessaires au fonctionnement de l'agent.

### Technologies utilisées

| Technologie | Utilisation |
|---|---|
| Java JDK 21 | Développement de l'agent |
| PowerShell | Collecte des informations système |
| WinRM | Administration et supervision à distance |
| Windows 11 | Poste principal |
| Windows 10 | Machines supervisées |
| HTML | Tableaux de bord et rapports |
| Visual Studio Code | Environnement de développement |
| GitHub | Documentation et gestion du projet |

---

# 🎯 Résultats du projet

Smart IT Agent V9 illustre la mise en place d'une solution de supervision informatique centralisée.

Les principales fonctionnalités présentées sont :

✅ Supervision locale et distante des machines Windows.

✅ Collecte des performances CPU, RAM et disque.

✅ Surveillance des services Windows.

✅ Communication distante avec WinRM.

✅ Centralisation des informations de supervision.

✅ Détection et historisation des incidents.

✅ Visualisation des données dans des tableaux de bord.

✅ Génération de rapports informatiques.

✅ Notification automatique par email.

✅ Remédiation automatisée du service Spooler.

---

# 🚀 Perspectives d'amélioration

Les prochaines évolutions envisagées pour Smart IT Agent comprennent :

- La supervision d'un plus grand nombre de machines.
- L'intégration de serveurs Windows Server.
- La prise en charge des systèmes Linux.
- L'amélioration des mécanismes de remédiation automatique.
- La création d'une interface Web centralisée.
- Le développement d'un système de gestion des incidents.
- L'ajout de nouvelles fonctionnalités d'analyse des performances.

---

# 👨‍💻 Conclusion

**Smart IT Agent V9** est un projet de développement et d'administration des systèmes informatiques combinant Java, PowerShell, WinRM et les technologies de supervision.

Il permet de mettre en pratique plusieurs compétences techniques :

- Administration Windows.
- Supervision informatique.
- Programmation Java.
- Automatisation PowerShell.
- Administration distante.
- Gestion des incidents.
- Développement de tableaux de bord.
- Remédiation automatisée.

Ce projet constitue une application pratique des concepts d'administration systèmes, réseaux et automatisation informatique.
