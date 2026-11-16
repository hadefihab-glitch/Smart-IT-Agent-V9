# Supervision-Parc.ps1
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

$collecteur = Join-Path $PSScriptRoot "Collecte-PC.ps1"
if (!(Test-Path $collecteur)) {
    throw "Collecte-PC.ps1 est absent."
}

$comptePC1 = Get-Credential -Message "Compte administrateur de PC1"
$comptePC2 = Get-Credential -Message "Compte Windows de PC2"
if (!$comptePC1 -or !$comptePC2) {
    throw "Identification annulee."
}

$sortie = Join-Path $PSScriptRoot "resultats"
New-Item -ItemType Directory -Path $sortie -Force | Out-Null

$dashboard = Join-Path $sortie "dashboard.html"
$rapport = Join-Path $sortie "rapport-supervision.html"
$historique = Join-Path $sortie "mesures.csv"
$journal = Join-Path $sortie "incidents.csv"

$precedents = @{}
$suiviMail = @{}

function EnvoyerMail($sujet, $texte) {
    $message = $null
    $smtp = $null

    try {
        $gmail = Import-Clixml (
            Join-Path $PSScriptRoot "gmail-credential.xml"
        )

        $message = New-Object System.Net.Mail.MailMessage
        $message.From = $gmail.UserName
        $message.To.Add("hadafihab6@gmail.com")
        $message.Subject = $sujet
        $message.Body = $texte
        $message.SubjectEncoding = [System.Text.Encoding]::UTF8
        $message.BodyEncoding = [System.Text.Encoding]::UTF8

        $smtp = New-Object System.Net.Mail.SmtpClient(
            "smtp.gmail.com", 587
        )
        $smtp.EnableSsl = $true
        $smtp.UseDefaultCredentials = $false
        $smtp.Credentials = $gmail.GetNetworkCredential()
        $smtp.Timeout = 20000

        $smtp.Send($message)

        EcrireJournal "actions.log" "EMAIL" "ENVOYE" $sujet
        return $true
    }
    catch {
        EcrireJournal "actions.log" "EMAIL" "ECHEC" `
            $_.Exception.Message
        return $false
    }
    finally {
        if ($null -ne $message) { $message.Dispose() }
        if ($null -ne $smtp) { $smtp.Dispose() }
    }
}

function VerifierAlerteMail($machine, $adresse, $echec, $detailErreur) {
    if ($machine -notin @("PC1", "PC2")) { return }

    if (!$suiviMail.ContainsKey($machine)) {
        $suiviMail[$machine] = @{
            Echecs = 0
            AlerteEnvoyee = $false
            DernierEssai = [datetime]::MinValue
        }
    }

    $suivi = $suiviMail[$machine]

    if ($echec) {
        $suivi.Echecs++

        if ($suivi.Echecs -lt 2 -or $suivi.AlerteEnvoyee) {
            return
        }

        # Espacer les nouvelles tentatives si Gmail est indisponible.
        if (((Get-Date) - $suivi.DernierEssai).TotalSeconds -lt 120) {
            return
        }

        $suivi.DernierEssai = Get-Date

        $texte = @"
Machine : $machine
Adresse IP : $adresse
Date : $(Get-Date -Format "dd/MM/yyyy HH:mm:ss")

Deux collectes consecutives ont echoue.
La machine peut etre arretee ou inaccessible sur le reseau.

Erreur :
$detailErreur
"@

        if (EnvoyerMail "SmartITAgent - ALERTE : $machine inaccessible" $texte) {
            $suivi.AlerteEnvoyee = $true
        }
    }
    else {
        $suivi.Echecs = 0

        if (!$suivi.AlerteEnvoyee) { return }

        if (((Get-Date) - $suivi.DernierEssai).TotalSeconds -lt 120) {
            return
        }

        $suivi.DernierEssai = Get-Date

        $texte = @"
Machine : $machine
Adresse IP : $adresse
Date : $(Get-Date -Format "dd/MM/yyyy HH:mm:ss")

La collecte fonctionne de nouveau.
Consultez le dashboard pour les eventuelles alertes de ressources.
"@

        if (EnvoyerMail "SmartITAgent - RETOUR : $machine accessible" $texte) {
            $suivi.AlerteEnvoyee = $false
        }
    }
}
$debut = Get-Date
$ouvert = $false
$taches = @()

# Limites de remediation pour cette session.
$reparation = @{
    Tentatives = 0
    Derniere = [datetime]::MinValue
    Message = "Aucune tentative."
}

function EcrireJournal($fichier, $machine, $type, $message) {
    $message = ([string]$message) -replace "[\r\n]+", " "
    $ligne = "{0} | {1} | {2} | {3}" -f `
        (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), `
        $machine, $type, $message

    Add-Content -LiteralPath (Join-Path $PSScriptRoot $fichier) `
        -Value $ligne -Encoding UTF8
}

function JournalRemediation($type, $message) {
    EcrireJournal "actions.log" "PC1" $type $message
    EcrireJournal "remediation.log" "PC1" $type $message
}

function Html($texte) {
    [System.Net.WebUtility]::HtmlEncode([string]$texte)
}

function AfficherMesure($valeur) {
    if ($null -eq $valeur) { return "Indisponible" }
    return ("{0:N1} %" -f [double]$valeur)
}

function DemarrerSpoolerPC1 {
    if ($reparation.Tentatives -ge 2) {
        return "Limite atteinte : deux tentatives pour cette session."
    }

    if (((Get-Date) - $reparation.Derniere).TotalSeconds -lt 120) {
        return "Nouvelle tentative possible apres deux minutes."
    }

    $reparation.Tentatives++
    $reparation.Derniere = Get-Date

    JournalRemediation "REMEDIATION_DEBUT" `
        "Spooler : tentative $($reparation.Tentatives)/2."

    $job = $null

    try {
        $job = Invoke-Command -ComputerName "192.168.98.129" `
            -Credential $comptePC1 -AsJob -ErrorAction Stop `
            -ScriptBlock {
                $ErrorActionPreference = "Stop"
                $service = Get-Service -Name "Spooler" -ErrorAction Stop

                # Reverification sur PC1 avant toute action.
                if ($service.Status -eq "Running") {
                    return [PSCustomObject]@{
                        Etat = "RUNNING"
                        Action = "DEJA_ACTIF"
                    }
                }

                if ($service.Status -ne "Stopped") {
                    throw "Spooler est dans l'etat $($service.Status)."
                }

                # Ne pas modifier un service volontairement desactive.
                $configuration = Get-CimInstance Win32_Service `
                    -Filter "Name='Spooler'" -ErrorAction Stop

                if ($configuration.StartMode -eq "Disabled") {
                    throw "Spooler est desactive. Demarrage refuse."
                }

                Start-Service -Name "Spooler" -ErrorAction Stop
                $service.WaitForStatus(
                    [System.ServiceProcess.ServiceControllerStatus]::Running,
                    [TimeSpan]::FromSeconds(10)
                )
                $service.Refresh()

                if ($service.Status -ne "Running") {
                    throw "Le fonctionnement de Spooler n'est pas confirme."
                }

                [PSCustomObject]@{
                    Etat = "RUNNING"
                    Action = "DEMARRE"
                }
            }

        $job | Wait-Job -Timeout 20 | Out-Null

        if ($job.State -ne "Completed") {
            if ($job.State -eq "Failed") {
                throw $job.ChildJobs[0].JobStateInfo.Reason
            }
            throw "Delai depasse : resultat du demarrage non confirme."
        }

        $resultat = @(Receive-Job $job -ErrorAction Stop)
        if ($resultat.Count -ne 1 -or $resultat[0].Etat -ne "RUNNING") {
            throw "Reponse de verification invalide."
        }

        if ($resultat[0].Action -eq "DEMARRE") {
            $message = "Spooler demarre sur PC1 ; RUNNING verifie."
        }
        else {
            $message = "Spooler etait deja RUNNING lors de la verification."
        }

        JournalRemediation "REMEDIATION_SUCCESS" $message
        return $message
    }
    catch {
        $message = "Spooler : echec ou resultat non confirme. " +
            $_.Exception.Message

        JournalRemediation "REMEDIATION_ECHEC" $message
        EcrireJournal "incidents.log" "PC1" `
            "REMEDIATION_ECHEC" $message

        return $message
    }
    finally {
        if ($null -ne $job) {
            Stop-Job $job -ErrorAction SilentlyContinue
            Remove-Job $job -Force -ErrorAction SilentlyContinue
        }
    }
}

EcrireJournal "actions.log" "AGENT" "DEMARRAGE" `
    "Supervision des trois machines ; remediation Spooler sur PC1."

$style = @"
<style>
body{font-family:Segoe UI,Arial;background:#0f172a;color:#e2e8f0;
margin:0;padding:28px}
p,small{color:#94a3b8}
.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));
gap:18px;margin:24px 0}
.card{background:#1e293b;border:1px solid #334155;
border-radius:12px;padding:22px}
.OK{color:#4ade80}.ALERTE{color:#fbbf24}.ERREUR{color:#f87171}
table{width:100%;border-collapse:collapse}
td,th{text-align:left;padding:9px;border-bottom:1px solid #334155}
a{color:#38bdf8}
@media print{
body{background:white;color:black;padding:10px}
.card{background:white;border:1px solid #aaa;break-inside:avoid}
p,small{color:#444}nav,button{display:none}
}
</style>
"@

try {
    while ($true) {
        $instant = Get-Date
        $cibles = @(
            @{Nom="Windows 11"; IP="Local"; Credential=$null},
            @{Nom="PC1"; IP="192.168.98.129"; Credential=$comptePC1},
            @{Nom="PC2"; IP="192.168.98.130"; Credential=$comptePC2}
        )

        $taches = @(
            foreach ($cible in $cibles) {
                $job = Start-Job -ArgumentList @(
                    $collecteur, $cible.IP, $cible.Credential
                ) -ScriptBlock {
                    param($fichier, $ip, $identifiants)
                    $ErrorActionPreference = "Stop"

                    if ($ip -eq "Local") {
                        & $fichier
                    }
                    else {
                        Invoke-Command -ComputerName $ip `
                            -Credential $identifiants `
                            -FilePath $fichier -ErrorAction Stop
                    }
                }

                [PSCustomObject]@{Cible=$cible; Job=$job}
            }
        )

        $taches.Job | Wait-Job -Timeout 30 | Out-Null
        $cartes = @()
        $lignes = @()

        foreach ($tache in $taches) {
            $nom = $tache.Cible.Nom
            $ip = $tache.Cible.IP
            $etat = "OK"
            $details = @()
            $cpu = $null
            $ram = $null
            $disque = $null
            $servicesHtml = ""
            $noteRemediation = ""
            $servicesLog = @()

            try {
                if ($tache.Job.State -ne "Completed") {
                    if ($tache.Job.State -eq "Failed") {
                        throw $tache.Job.ChildJobs[0].JobStateInfo.Reason
                    }
                    throw "Delai de collecte depasse."
                }

                $brut = @(Receive-Job $tache.Job -ErrorAction Stop)
                if ($brut.Count -eq 0) {
                    throw "Aucune donnee recue."
                }

                if ($brut[0] -is [string]) {
                    $mesure = ($brut -join "`n") | ConvertFrom-Json
                }
                else {
                    $mesure = $brut[0]
                }

                foreach ($champ in @("CPU","RAM","DISQUE","SERVICES")) {
                    if ($mesure.PSObject.Properties.Name -notcontains $champ) {
                        throw "Champ absent : $champ."
                    }
                }

                $cpu = $mesure.CPU
                $ram = $mesure.RAM
                $disque = $mesure.DISQUE

                foreach ($champ in @("CPU","RAM","DISQUE")) {
                    $valeur = $mesure.$champ

                    if ($null -eq $valeur) {
                        $details += "$champ : mesure indisponible"
                    }
                    elseif ([double]$valeur -lt 0 -or
                            [double]$valeur -gt 100 -or
                            [double]::IsNaN([double]$valeur)) {
                        throw "Mesure $champ invalide."
                    }
                    elseif ([double]$valeur -ge 90) {
                        $details += "$champ au-dessus du seuil de 90 %"
                    }
                }

                foreach ($service in @(
                    "Spooler","W32Time","BITS","SmartIT-Test"
                )) {
                    if ($mesure.SERVICES -is [System.Collections.IDictionary]) {
                        $statut = [string]$mesure.SERVICES[$service]
                    }
                    else {
                        $statut = [string]$mesure.SERVICES.$service
                    }

                    if (!$statut) { $statut = "UNKNOWN" }
                    $statut = $statut.ToUpperInvariant()

                    $servicesLog += "$service=$statut"
                    $servicesHtml += "<tr><td>$(Html $service)</td>" +
                        "<td>$(Html $statut)</td></tr>"

                    if ($statut -in @("ERROR","UNKNOWN")) {
                        $details += "Etat du service $service indisponible"
                    }

                    if ($service -eq "Spooler" -and $statut -ne "RUNNING") {
                        $details += "Spooler : $statut (attendu : RUNNING)"
                    }

                    # Seule cette combinaison est autorisee.
                    if ($nom -eq "PC1" -and
                        $service -eq "Spooler" -and
                        $statut -eq "STOPPED") {

                        EcrireJournal "actions.log" "PC1" `
                            "SERVICE_ARRETE_DETECTE" "Spooler=STOPPED"

                        $reparation.Message = DemarrerSpoolerPC1
                        $noteRemediation = $reparation.Message
                    }
                }

                if ($details.Count -gt 0) { $etat = "ALERTE" }
            }
            catch {
                $etat = "ERREUR"
                $details = @($_.Exception.Message)
                $cpu = $null
                $ram = $null
                $disque = $null
                $servicesHtml = ""
            }
            finally {
                Stop-Job $tache.Job -ErrorAction SilentlyContinue
                Remove-Job $tache.Job -Force -ErrorAction SilentlyContinue
            }

            $detail = $details -join " ; "
            $signature = "$etat|$detail"
VerifierAlerteMail -machine $nom -adresse $ip `
    -echec ($etat -eq "ERREUR") -detailErreur $detail

            $texteMesures = "IP=$ip | CPU=$(AfficherMesure $cpu)" +
                " | RAM=$(AfficherMesure $ram)" +
                " | DISQUE=$(AfficherMesure $disque)" +
                " | ETAT=$etat"

            if ($etat -ne "ERREUR") {
                $texteMesures += " | " + ($servicesLog -join " | ")
            }

            EcrireJournal "monitoring.log" $nom "MESURES" $texteMesures

            if ($etat -eq "ERREUR") {
                EcrireJournal "actions.log" $nom "COLLECTE_ECHEC" $detail
            }
            else {
                EcrireJournal "actions.log" $nom "COLLECTE_SUCCESS" `
                    "Mesures et etats des services recuperes"
            }

            if ($precedents[$nom] -ne $signature) {
                if ($etat -ne "OK" -or $precedents.ContainsKey($nom)) {
                    $typeIncident = $etat
                    $texteIncident = $detail

                    if ($etat -eq "OK") {
                        $typeIncident = "RECOVERY"
                        $texteIncident = "Retour a la normale"
                    }

                    EcrireJournal "incidents.log" $nom `
                        $typeIncident $texteIncident

                    [PSCustomObject]@{
                        Date=$instant.ToString("o")
                        Machine=$nom
                        Etat=$typeIncident
                        Detail=$texteIncident
                    } | Export-Csv $journal -Append `
                        -NoTypeInformation -Encoding UTF8
                }

                $precedents[$nom] = $signature
            }

            [PSCustomObject]@{
                Date=$instant.ToString("o")
                Machine=$nom
                IP=$ip
                CPU=$cpu
                RAM=$ram
                DISQUE=$disque
                Etat=$etat
                Detail=$detail
            } | Export-Csv $historique -Append `
                -NoTypeInformation -Encoding UTF8

            if ($nom -eq "PC1" -and !$noteRemediation) {
                $noteRemediation = $reparation.Message
            }

            $cartes += @"
<section class="card">
<h2>$(Html $nom)</h2>
<small>$(Html $ip)</small>
<h3 class="$etat">$etat</h3>
<table>
<tr><td>CPU</td><td>$(AfficherMesure $cpu)</td></tr>
<tr><td>RAM</td><td>$(AfficherMesure $ram)</td></tr>
<tr><td>Disque C:</td><td>$(AfficherMesure $disque)</td></tr>
</table>
<h3>Services observes pendant la collecte</h3>
<table>$servicesHtml</table>
<p>$(Html $detail)</p>
<p>$(Html $noteRemediation)</p>
</section>
"@

            $lignes += "<tr><td>$(Html $nom)</td>" +
                "<td class='$etat'>$etat</td><td>$(Html $detail)</td></tr>"
        }

        $contenu = @"
<h1>Smart IT - Supervision du parc</h1>
<p>Cycle : $($instant.ToString("dd/MM/yyyy HH:mm:ss"))<br>
Session : $($debut.ToString("dd/MM/yyyy HH:mm:ss"))</p>
<div class="grid">$($cartes -join "`n")</div>
<h2>Diagnostic du cycle</h2>
<table><tr><th>Machine</th><th>Etat</th><th>Details</th></tr>
$($lignes -join "`n")</table>
<h2>Remediation automatique</h2>
<p>Autorisee uniquement pour Spooler sur PC1.
Deux tentatives maximum par session, espacees de deux minutes.
Le type de demarrage du service n'est pas modifie.</p>
<p>Les mesures affichent l'etat observe avant la remediation.
Le prochain cycle confirme le nouvel etat dans le tableau.</p>
<p>Seuil ressources : 90 %. Spooler attendu en fonctionnement.
Pause entre les cycles : 10 secondes.</p>
"@

        @"
<!doctype html><html lang="fr"><head><meta charset="utf-8">
<meta http-equiv="refresh" content="10">
<title>Supervision du parc</title>$style</head><body>
<nav><a href="rapport-supervision.html" target="_blank">Ouvrir le rapport</a></nav>
$contenu
</body></html>
"@ | Set-Content $dashboard -Encoding UTF8

        @"
<!doctype html><html lang="fr"><head><meta charset="utf-8">
<title>Rapport de supervision</title>$style</head><body>
<button onclick="window.print()">Imprimer / Enregistrer en PDF</button>
<p>Rapport du dernier cycle. Historique dans les CSV et journaux.</p>
$contenu
</body></html>
"@ | Set-Content $rapport -Encoding UTF8

        Write-Host "$($instant.ToString('HH:mm:ss')) : trois machines traitees."

        if (!$ouvert) {
            Start-Process $dashboard
            $ouvert = $true
        }

        Start-Sleep -Seconds 10
    }
}
finally {
    foreach ($tache in $taches) {
        Stop-Job $tache.Job -ErrorAction SilentlyContinue
        Remove-Job $tache.Job -Force -ErrorAction SilentlyContinue
    }
}
