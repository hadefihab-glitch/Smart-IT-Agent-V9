  # 📸 Captures du projet — Smart IT Agent V9

Cette section présente les différentes étapes de développement, de configuration, de supervision et de remédiation automatique du projet **Smart IT Agent V9**.

---

## 🖥️ 1. SMART IT AGENT V9

Présentation générale de l'architecture du projet.

Smart IT Agent V9 repose sur trois fonctionnalités principales : la supervision des ressources informatiques, la détection des incidents et la remédiation automatique.

![SMART IT AGENT V9](screenshots/SMART%20IT%20AGENT%20V9.jpg)

---

## 💻 2. Développement du Smart IT Agent en Java

Développement de l'agent principal en Java JDK 21 sous Visual Studio Code.

Le programme permet de surveiller les ressources système et de centraliser les informations collectées.

![Développement du Smart IT Agent en Java](screenshots/Développement%20du%20Smart%20IT%20Agent%20en%20Java.png)

---

## ⚙️ 3. Développement du script PowerShell de collecte

Création du script PowerShell permettant de récupérer les informations système des machines Windows.

Le script collecte les données CPU, RAM, disque et l'état des services Windows.

![Développement du script PowerShell de collecte](screenshots/Développement%20du%20script%20PowerShell%20de%20collecte%20des%20données%20système.png)

---

## 🌐 4. Vérification de la Connectivité Réseau et Configuration IP

Configuration de l'adresse IP de la machine virtuelle PC1.

Vérification de la connectivité réseau entre le poste principal Windows 11 et les machines distantes.
![Vérification de la Connectivité Réseau et Configuration IP](screenshots/Vérification%20de%20la%20Connectivité%20Réseau%20et%20Configuration%20IP%20%28PC1%29%20%282%29.jpg)
---

## 🔐 5. Configuration WinRM et test PowerShell distant

Configuration de Windows Remote Management (WinRM) afin d'autoriser l'exécution de commandes PowerShell à distance.

Cette configuration permet à Smart IT Agent de superviser les machines Windows sans installer Java sur les postes clients.

![Configuration WinRM et test PowerShell distant](screenshots/Configuration%20WinRM%20et%20test%20PowerShell%20distant.png)

---

## ✅ 6. Configuration WinRM et Tests PowerShell Réussis

Vérification de la communication entre Windows 11, PC1 et PC2.

Les tests confirment l'accessibilité du port TCP 5985 utilisé par WinRM HTTP.

![Configuration WinRM et Tests PowerShell Réussis](screenshots/Configuration%20WinRM%20et%20Tests%20PowerShell%20Réussis.png)

---

## ▶️ 7. Exécution Smart IT Agent V9 en PowerShell

Compilation et lancement de l'agent Java depuis PowerShell.

Le programme réalise des cycles de supervision sur trois machines :

- Windows 11 : machine principale.
- PC1 : Windows 10 distant.
- PC2 : Windows 10 distant.

![Exécution Smart IT Agent V9 en PowerShell](screenshots/Exécution%20Smart%20IT%20Agent%20V9%20en%20PowerShell.png)

---

## 📊 8. Journal de monitoring en temps réel

Enregistrement des informations collectées dans le fichier `monitoring.log`.

Le journal contient les mesures CPU, RAM, disque et l'état des machines supervisées.

![Journal de monitoring en temps réel](screenshots/Journal%20de%20monitoring%20en%20temps%20réel.png)

---

## 🚨 9. Journal des incidents Smart IT Agent

Historisation des anomalies détectées dans le fichier `incidents.log`.

Le journal contient les événements **CRITICAL**, **ALERTE** et **RECOVERY**.

Il permet de suivre les incidents et les retours à la normale.

![Journal des incidents Smart IT Agent](screenshots/Journal%20des%20incidents%20Smart%20IT%20Agent.png)

---

## 📈 10. Tableau de Bord de Supervision Globale du Parc Informatique

Visualisation centralisée de l'état des trois machines supervisées.

Le tableau de bord présente :

- L'utilisation du CPU.
- L'utilisation de la RAM.
- L'utilisation du disque.
- L'état des services Windows.
- Les alertes détectées.

![Tableau de Bord de Supervision Globale du Parc Informatique](screenshots/Tableau%20de%20Bord%20de%20Supervision%20Globale%20du%20Parc%20Informatique%20%28Smart%20IT%29.jpg)

---

## ❌ 11. Erreur de Connexion et d’Accès aux Données de Supervision

Détection d'un problème de communication avec la machine distante PC1.

Lorsque la collecte échoue, Smart IT Agent affiche un état d'erreur et les informations de diagnostic.

![Erreur de Connexion et d’Accès aux Données de Supervision](screenshots/Erreur%20de%20Connexion%20et%20d’Accès%20aux%20Données%20de%20Supervision.png)

---

## 📧 12. Alerte Smart IT et notification automatique

Détection d'une panne sur PC1 et envoi automatique d'une notification par email.

Le message contient :

- Le nom de la machine concernée.
- Son adresse IP.
- La date et l'heure de l'incident.
- Les détails de l'erreur.
- Les informations utiles au diagnostic.

![Alerte Smart IT et notification automatique](screenshots/Alerte%20Smart%20IT%20et%20notification%20automatique.png)

---

## 🔧 13. Supervision et Auto-Remédiation du Service Spooler

Démonstration de la détection et de la résolution automatique d'un incident sur le service Windows Spooler de PC1.

Après détection de l'arrêt du service, Smart IT Agent exécute une tentative de redémarrage.

Le journal de remédiation confirme le retour du service à l'état **RUNNING**.

![Supervision et Auto-Remédiation du Service Spooler](screenshots/Supervision%20et%20Auto-Remédiation%20du%20Service%20Spooler.png)

---

## 📄 14. Rapport de supervision informatique

Génération d'un rapport de supervision présentant les informations collectées sur les machines.

Le rapport contient les performances système, l'état des services et les alertes détectées.

![Rapport de supervision informatique](screenshots/Rapport%20de%20supervision%20informatique.png)

---

## 📊 15. Tableau de bord des journaux système

Présentation du tableau de bord permettant de consulter les informations de supervision et les journaux système.

Cette interface facilite l'analyse des événements et le suivi de l'état du parc informatique.

![Tableau de bord des journaux système](screenshots/Tableau%20de%20bord%20des%20journaux%20système.png)

---
