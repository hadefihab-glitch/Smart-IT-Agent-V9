# Collecte-PC.ps1 — collecte locale ou exécutée à distance via WinRM
$ErrorActionPreference = "Stop"

function PourcentageUtilise($total, $libre) {
    if ($null -eq $total -or $total -le 0 -or $null -eq $libre) {
        return $null
    }

    return [math]::Round((($total - $libre) / $total) * 100, 2)
}

$cpu = (
    Get-CimInstance Win32_Processor |
    Measure-Object -Property LoadPercentage -Average
).Average

$os = Get-CimInstance Win32_OperatingSystem
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"

$servicesCibles = @(
    "Spooler",
    "W32Time",
    "BITS",
    "SmartIT-Test"
)

$servicesStatus = [ordered]@{}

foreach ($nom in $servicesCibles) {
    try {
        $service = Get-Service -Name $nom -ErrorAction Stop
        $servicesStatus[$nom] = $service.Status.ToString().ToUpperInvariant()
    }
    catch {
        if ($_.FullyQualifiedErrorId -like "NoServiceFoundForGivenName*") {
            $servicesStatus[$nom] = "NOT_FOUND"
        }
        else {
            $servicesStatus[$nom] = "ERROR"
        }
    }
}

$cpuPct = $null
if ($null -ne $cpu) {
    $cpuPct = [math]::Round([double]$cpu, 2)
}

[PSCustomObject]@{
    MACHINE = $env:COMPUTERNAME
    DATE = (Get-Date).ToString("o")
    CPU = $cpuPct
    RAM = PourcentageUtilise $os.TotalVisibleMemorySize $os.FreePhysicalMemory
    DISQUE = PourcentageUtilise $disk.Size $disk.FreeSpace
    SERVICES = $servicesStatus
}

$resultat | ConvertTo-Json -Compress
