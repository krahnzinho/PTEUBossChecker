Write-Host "Boss Notifier is running... Press Ctrl+C to stop."

#auto detects local timezone
$localOffset = [System.TimeZoneInfo]::Local.BaseUtcOffset.TotalHours
$timezoneOffset = -3 - $localOffset

$bossSchedule = @(
    @{ Hour = 11; Bosses = @("Valento", "Kelvezu", "Gorgoniac", "Draxos", "Eadric/Vault") }
    @{ Hour = 12; Bosses = @("Chaos Queen", "Blood Prince", "Devil Shy", "Primal Golem", "Deius") }
    @{ Hour = 13; Bosses = @("Valento", "Mokova", "Tulla") }
    @{ Hour = 14; Bosses = @("Chaos Queen", "Kelvezu", "Gorgoniac", "Deius", "Greedy", "Aragonian", "Eadric/Vault") }
    @{ Hour = 15; Bosses = @("Valento", "Blood Prince", "Draxos", "Yagditha") }
    @{ Hour = 16; Bosses = @("Chaos Queen", "Mokova", "Devil Shy", "Ignis", "Deius") }
    @{ Hour = 17; Bosses = @("Valento", "Kelvezu", "Gorgoniac", "Tulla", "Eadric/Vault") }
    @{ Hour = 18; Bosses = @("Chaos Queen", "Blood Prince", "Eadric/Vault", "Primal Golem", "Deius") }
    @{ Hour = 19; Bosses = @("Valento", "Mokova", "Draxos") }
    @{ Hour = 20; Bosses = @("Chaos Queen", "Kelvezu", "Gorgoniac", "Devil Shy", "Greedy", "Aragonian", "Eadric/Vault") }
    @{ Hour = 21; Bosses = @("Valento", "Blood Prince", "Yagditha", "Tulla") }
    @{ Hour = 22; Bosses = @("Chaos Queen", "Mokova", "Ignis", "Deius") }
    @{ Hour = 23; Bosses = @("Valento", "Kelvezu", "Gorgoniac", "Draxos", "Eadric/Vault") }
    @{ Hour = 0; Bosses = @("Chaos Queen", "Blood Prince", "Devil Shy", "Primal Golem", "Deius") }
    @{ Hour = 1; Bosses = @("Valento", "Mokova", "Tulla") }
    @{ Hour = 2; Bosses = @("Chaos Queen", "Kelvezu", "Gorgoniac", "Deius", "Greedy", "Aragonian", "Eadric/Vault") }
    @{ Hour = 3; Bosses = @("Valento", "Blood Prince", "Draxos", "Yagditha") }
    @{ Hour = 4; Bosses = @("Chaos Queen", "Mokova", "Devil Shy", "Ignis", "Deius") }
    @{ Hour = 5; Bosses = @("Valento", "Kelvezu", "Gorgoniac", "Tulla", "Eadric/Vault") }
    @{ Hour = 6; Bosses = @("Chaos Queen", "Blood Prince", "Eadric/Vault", "Primal Golem", "Deius") }
    @{ Hour = 7; Bosses = @("Valento", "Mokova", "Draxos") }
    @{ Hour = 8; Bosses = @("Chaos Queen", "Kelvezu", "Gorgoniac", "Devil Shy", "Greedy", "Aragonian", "Eadric/Vault") }
    @{ Hour = 9; Bosses = @("Valento", "Blood Prince", "Yagditha", "Tulla") }
    @{ Hour = 10; Bosses = @("Chaos Queen", "Mokova", "Ignis", "Deius") }
)

# Localizações conhecidas
$locations = @{
    "Chaos Queen" = "Ice 1"
    "Valento" = "Ice 2"
    "Kelvezu" = "Kelvezu Lair"
    "Blood Prince" = "Lost 1"
    "Mokova" = "Lost 2"
}

# Função para mostrar notificação toast no Windows
function Show-ToastNotification {
    param (
        [string]$title,
        [string]$message
    )
    Add-Type -AssemblyName System.Windows.Forms
    $balloon = New-Object System.Windows.Forms.NotifyIcon
    $balloon.Icon = [System.Drawing.SystemIcons]::Information
    $balloon.BalloonTipIcon = "Info"
    $balloon.BalloonTipText = $message
    $balloon.BalloonTipTitle = $title
    $balloon.Visible = $true
    $balloon.ShowBalloonTip(10000)
}

# Loop infinito (pressione Ctrl+C para parar)
while ($true) {
    $nowLocal = Get-Date
    $nowUTC = $nowLocal.ToUniversalTime()
    $nowSP = $nowUTC.addHours(-3)

    $checkHour = $now.Hour
    $checkMinute = $now.Minute

    Write-Host "[LOG] Local: $($nowLocal.ToString("HH:mm")) | São Paulo: $($nowSP.ToString("HH:mm"))"

    if ($checkMinute -eq 20) {
        $entry = $bossSchedule | Where-Object { $_.Hour -eq $checkHour }
        if ($entry) {
            $bossList = $entry.Bosses | ForEach-Object {
                $loc = if ($locations.ContainsKey($_)) { "$_ ($($locations[$_]))" } else { $_ }
                $loc
            }

            $message = "Spawning in 10 min: " + ($bossList -join ", ")
            Write-Host "[NOTIFY] $message"
            Show-ToastNotification -title "Boss Reminder" -message $message
        } else {
            Write-Host "[INFO] No boss is going to spawn now."
        }
    }

    Start-Sleep -Seconds 60
}