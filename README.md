# 🖥️ Smart IT Agent V9 — Intelligent IT Monitoring & Automated Remediation

### Systèmes • Réseaux • Supervision • Automatisation IT

---

## 📌 Présentation du projet

**Smart IT Agent V9** est une solution de supervision informatique centralisée que j'ai développée en utilisant **Java JDK 21, PowerShell et Windows Remote Management (WinRM)**.

L'objectif principal de ce projet est de concevoir un agent capable de superviser plusieurs machines Windows depuis un seul poste administrateur, de détecter automatiquement les anomalies, d'envoyer des notifications et d'effectuer certaines actions de remédiation.

L'infrastructure comprend trois machines : un poste principal sous Windows 11 et deux machines virtuelles sous Windows 10.

L'agent fonctionne sans nécessiter l'installation de Java sur les machines distantes.

Le projet intègre également :

- Un tableau de bord HTML.
- Une collecte régulière des performances système.
- Une surveillance des services Windows.
- Un système de détection des incidents.
- Des notifications automatiques par email.
- Un mécanisme de remédiation automatique.
- Des journaux de supervision.
- Une génération de rapports.

---

## 🎯 Objectifs du projet

- Centraliser la supervision d'un parc informatique Windows.
- Surveiller les ressources CPU, RAM et disque.
- Contrôler l'état des services Windows.
- Superviser plusieurs machines à distance avec WinRM.
- Détecter les dépassements de seuil.
- Identifier les machines inaccessibles.
- Envoyer automatiquement des notifications par email.
- Automatiser certaines actions correctives.
- Conserver un historique des événements.
- Générer des rapports de supervision.
- Visualiser l'état du parc depuis un tableau de bord.

---

## 🛠️ Technologies utilisées

| Technologie | Utilisation |
|---|---|
| Java JDK 21 | Développement de l'agent principal |
| PowerShell | Collecte des données système |
| WinRM | Administration distante |
| Windows 11 | Poste principal |
| Windows 10 | Machines supervisées |
| VMware Workstation | Virtualisation |
| Visual Studio Code | Développement |
| HTML / CSS | Dashboard et rapports |
| SMTP | Notifications email |
| NSSM | Exécution comme service Windows |

---

# 🏗️ Architecture de l'infrastructure

L'architecture repose sur une supervision centralisée.

### Machines utilisées

| Machine | Système | Adresse IP | Fonction |
|---|---|---|---|
| Windows 11 | Windows 11 | Local | Agent principal |
| PC1 | Windows 10 | 192.168.98.129 | Client supervisé |
| PC2 | Windows 10 | 192.168.98.130 | Client supervisé |

### Architecture logique

```text
                  SMART IT AGENT V9
                    WINDOWS 11
                  Poste principal
                         |
                         |
                 Java + PowerShell
                         |
                       WinRM
                         |
              +----------+----------+
              |                     |
              |                     |
             PC1                   PC2
          Windows 10            Windows 10
        192.168.98.129        192.168.98.130
              |                     |
              +----------+----------+
                         |
                         v
                COLLECTE DES DONNÉES
                         |
              +----------+----------+
              |          |          |
             CPU        RAM       DISQUE
                         |
                  SERVICES WINDOWS
                         |
                         v
                 ANALYSE DES DONNÉES
                         |
              +----------+----------+
              |                     |
           ÉTAT OK                INCIDENT
              |                     |
              |              +------+------+
              |              |             |
              |           ALERTE       REMÉDIATION
              |              |             |
              |           EMAIL        ACTION
              |                            |
              +-------------+--------------+
                            |
                            v
                  JOURNAUX ET RAPPORTS
                            |
                            v
                     DASHBOARD HTML
```

---

# ⚙️ Fonctionnalités développées

## 1. Supervision des ressources système

Smart IT Agent collecte les informations suivantes :

- Utilisation du processeur (CPU).
- Utilisation de la mémoire vive (RAM).
- Utilisation du disque C:.
- État des services Windows.
- Disponibilité des machines.

La collecte est effectuée régulièrement afin de suivre l'évolution des performances.

## 2. Supervision à distance avec WinRM

WinRM permet au poste Windows 11 de communiquer avec PC1 et PC2.

L'agent utilise PowerShell pour récupérer les informations des machines distantes.

Cette architecture permet de centraliser la supervision sans installer Java sur chaque poste client.

## 3. Détection automatique des incidents

L'agent compare les valeurs collectées aux seuils configurés.

Exemples d'incidents :

- CPU supérieur à 90 %.
- RAM supérieure à 90 %.
- Utilisation excessive du disque.
- Arrêt d'un service surveillé.
- Échec de connexion à une machine distante.

Les anomalies sont enregistrées dans les journaux.

## 4. Notifications automatiques

Lorsqu'un incident est détecté, l'agent peut envoyer une notification par email.

Les notifications contiennent notamment :

- Le nom de la machine.
- Son adresse IP.
- La date de détection.
- La description de l'incident.
- Les informations utiles au diagnostic.

## 5. Remédiation automatique

Smart IT Agent intègre un mécanisme permettant de corriger certains incidents.

Un scénario de remédiation a été réalisé sur le service Windows **Spooler**.

Le fonctionnement comprend :

1. Détection de l'arrêt du service.
2. Identification de l'anomalie.
3. Exécution d'une tentative de redémarrage.
4. Vérification du nouvel état du service.
5. Enregistrement du résultat.

## 6. Génération des rapports

L'agent permet de produire des rapports HTML contenant les résultats de supervision.

Les rapports présentent :

- Les machines supervisées.
- Les performances système.
- L'état des services Windows.
- Les alertes détectées.
- Les informations de diagnostic.

Les rapports peuvent être exportés au format PDF depuis le navigateur.

---

# 📸 Captures du projet

## 🖥️ 1. Présentation générale — Smart IT Agent V9

Présentation du fonctionnement général du projet.

L'architecture repose sur trois fonctionnalités principales : la supervision, la détection des incidents et la remédiation automatisée.

![Présentation Smart IT Agent](screenshots/SMART%20IT%20AGENT%20V9.jpg)

---

## 💻 2. Développement du Smart IT Agent en Java

Développement de l'agent principal en Java JDK 21 sous Visual Studio Code.

Le programme collecte les informations système et analyse les ressources utilisées.

![Développement Java](screenshots/Développement%20du%20Smart%20IT%20Agent%20en%20Java.png)

---

## ⚙️ 3. Développement du script PowerShell de collecte

Création du script PowerShell chargé de récupérer les informations système des machines supervisées.

Le script collecte les données CPU, RAM, disque et l'état des services Windows.

![Script PowerShell](screenshots/NOM_COMPLET_A_VERIFIER.png)

---

## 🌐 4. Vérification de la connectivité réseau — PC1

Configuration de l'adresse IP de la machine virtuelle PC1.

Vérification de la connectivité réseau afin de préparer la supervision à distance.

![Connectivité PC1](screenshots/NOM_COMPLET_A_VERIFIER.png)

---

## 🔐 5. Configuration de WinRM

Configuration de Windows Remote Management sur les machines Windows.

WinRM permet l'exécution de commandes PowerShell à distance depuis le poste principal.

![Configuration WinRM](screenshots/NOM_COMPLET_A_VERIFIER.png)

---

## ✅ 6. Tests de connectivité WinRM — PC1 et PC2

Vérification de l'accessibilité du port TCP 5985 sur les machines distantes.

Les tests permettent de confirmer que les deux machines sont accessibles sur le port utilisé par WinRM HTTP.

![Tests WinRM](screenshots/NOM_COMPLET_A_VERIFIER.png)

---

## ▶️ 7. Exécution du Smart IT Agent V9

Compilation et lancement de l'agent Java depuis PowerShell.

Le programme exécute des cycles de supervision sur Windows 11, PC1 et PC2.

![Exécution Agent](screenshots/Exécution%20Smart%20IT%20Agent%20V9%20en%20PowerShell.png)

---

## 📊 8. Journal de monitoring — monitoring.log

Enregistrement des informations collectées pendant les cycles de supervision.

Le journal contient les mesures CPU, RAM, disque et l'état des machines.

![Monitoring Log](screenshots/Journal%20de%20monitoring%20en%20temps%20réel.png)

---

## 🚨 9. Journal des incidents — incidents.log

Historisation des incidents détectés.

Le fichier contient les événements de type **CRITICAL**, **ALERTE** et **RECOVERY**.

Il permet de consulter les anomalies et les retours à la normale.

![Incidents Log](screenshots/Journal%20des%20incidents%20Smart%20IT%20Agent.png)

---

## 📈 10. Tableau de bord de supervision globale

Visualisation centralisée de l'état des trois machines.

Le tableau de bord présente les performances CPU, RAM, disque et l'état des services Windows.

![Dashboard](screenshots/NOM_COMPLET_A_VERIFIER.png)

---

## ❌ 11. Détection d'une erreur de connexion — PC1

Détection d'un problème de communication avec PC1.

Lorsque la collecte échoue, le dashboard affiche un état d'erreur et les informations de diagnostic.

![Erreur PC1](screenshots/NOM_COMPLET_A_VERIFIER.png)

---

## 📧 12. Notification automatique par email

Démonstration de l'envoi d'une notification après détection d'une panne sur PC1.

L'email présente la machine concernée, son adresse IP, la date et les détails de l'erreur.

![Alerte Email](screenshots/Alerte%20Smart%20IT%20et%20notification%20automatique.png)

---

## 🔧 13. Remédiation automatique du service Spooler — PC1

Démonstration d'une action de remédiation sur le service Windows Spooler.

Après détection de son arrêt, l'agent exécute une tentative de redémarrage.

Le journal confirme le retour du service à l'état **RUNNING**.

![Remédiation Spooler](screenshots/NOM_COMPLET_A_VERIFIER.png)

---

## 📄 14. Rapport de supervision informatique

Génération d'un rapport présentant les informations des machines supervisées.

Le rapport contient les performances système, l'état des services et les alertes détectées.

![Rapport Supervision](screenshots/Rapport%20de%20supervision%20informatique.png)

---

## 📊 15. Tableau de bord des journaux système

Présentation du tableau de bord permettant de consulter les journaux et les informations de supervision.

![Tableau de bord des journaux système](screenshots/Tableau%20de%20bord%20des%20journaux%20système.png)

---
---

# 🎥 Vidéos de démonstration

## 🎬 1. Détection d'une panne sur PC1

Démonstration du comportement de Smart IT Agent lorsqu'une machine distante devient inaccessible.

[▶️ Voir la vidéo](videos/detection-panne-pc1.mp4)

---

## 🎬 2. Notification automatique par email

Démonstration de l'envoi d'un email d'alerte après la détection d'un incident.

[▶️ Voir la vidéo](videos/notification-email.mp4)

---

## 🎬 3. Remédiation automatique du service Spooler

Démonstration du redémarrage automatique du service Spooler sur PC1.

[▶️ Voir la vidéo](videos/remediation-spooler.mp4)

---

## 🎬 4. Génération du rapport de supervision

Démonstration de la génération et de la consultation d'un rapport de supervision.

[▶️ Voir la vidéo](videos/generation-rapport.mp4)

---

# 📁 Organisation du projet

```text
Smart-IT-Agent-V9/
│
├── README.md
│
├── screenshots/
│   ├── 01-presentation-agent.jpg
│   ├── 02-developpement-java.png
│   ├── 03-script-powershell.png
│   ├── 04-connectivite-pc1.jpg
│   ├── 05-configuration-winrm.png
│   ├── 06-tests-winrm.png
│   ├── 07-execution-agent.png
│   ├── 08-monitoring-log.png
│   ├── 09-incidents-log.png
│   ├── 10-dashboard.jpg
│   ├── 11-erreur-pc1.jpg
│   ├── 12-alerte-email.png
│   ├── 13-remediation-spooler.jpg
│   └── 14-rapport-supervision.png
│
├── videos/
│   ├── detection-panne-pc1.mp4
│   ├── notification-email.mp4
│   ├── remediation-spooler.mp4
│   └── generation-rapport.mp4
│
├── src/
│   ├── SmartITAgent.java
│   ├── SmartITServer.java
│   ├── ServiceMonitor.java
│   ├── RapportGenerator.java
│   ├── HistoriqueDashboard.java
│   └── RemediationEngine.java
│
└── scripts/
    ├── Collecte-PC.ps1
    └── Supervision-Parc.ps1
```

---

# 🧪 Tests et validation

| Test réalisé | Résultat |
|---|---|
| Supervision locale Windows 11 | ✅ Validé |
| Connectivité TCP WinRM vers PC1 | ✅ Validé |
| Connectivité TCP WinRM vers PC2 | ✅ Validé |
| Collecte des informations système | ✅ Validé |
| Supervision CPU, RAM et disque | ✅ Validé |
| Surveillance des services Windows | ✅ Validé |
| Détection des dépassements de seuil | ✅ Validé |
| Journalisation des incidents | ✅ Validé |
| Détection d'une machine inaccessible | ✅ Validé |
| Notification automatique par email | ✅ Démontrée |
| Remédiation du service Spooler | ✅ Démontrée |
| Génération du dashboard HTML | ✅ Validé |
| Génération du rapport de supervision | ✅ Validé |

---

# 🚀 Perspectives d'amélioration

Plusieurs évolutions sont envisagées pour améliorer Smart IT Agent :

- Intégration de l'intelligence artificielle pour l'analyse des incidents.
- Développement d'un moteur de diagnostic intelligent.
- Amélioration des mécanismes de remédiation automatique.
- Supervision d'un nombre plus important de machines.
- Intégration d'une base de données.
- Développement d'une interface Web interactive.
- Renforcement de la sécurité des communications WinRM.
- Ajout d'un système d'authentification.
- Amélioration des notifications.
- Intégration de nouvelles fonctionnalités d'automatisation.

---

# 🎓 Compétences développées

Ce projet m'a permis de mettre en pratique plusieurs compétences :

- Administration des systèmes Windows.
- Administration réseau.
- Virtualisation.
- Développement Java.
- Scripting PowerShell.
- Supervision informatique.
- Administration distante avec WinRM.
- Gestion et analyse des incidents.
- Automatisation des tâches IT.
- Développement de tableaux de bord.
- Génération de rapports techniques.

---

# 👨‍💻 Auteur

**Ihab Hadef**

Étudiant en cycle d'ingénieur informatique.

**Spécialisation : Systèmes, Réseaux & Cloud**

**Projet personnel : Smart IT Agent V9**

*Superviser • Détecter • Alerter • Remédier*
