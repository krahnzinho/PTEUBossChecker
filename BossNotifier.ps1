Write-Host "Boss Notifier is running... Press Ctrl+C to stop."

#when do you want to be notified, in minutes?
$notifyMinutesBeforeSpawn = 10

#auto detects local timezone
$localOffset = [System.TimeZoneInfo]::Local.BaseUtcOffset.TotalHours
$timezoneOffset = -3 - $localOffset #adapts from brazilian timezone

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

# boss locations
$locations = @{
    "Chaos Queen" = "Ice 1"
    "Valento" = "Ice 2"
    "Kelvezu" = "Kelvezu Lair"
    "Blood Prince" = "Lost 1"
    "Mokova" = "Lost 2"
    "Babel" = "Iron 1"
}

# show toast
function Show-ToastNotification {
    param (
        [string]$title,
        [string]$message
    )
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $balloon = New-Object System.Windows.Forms.NotifyIcon
    $balloon.Icon = [System.Drawing.SystemIcons]::Information
    $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
    $balloon.BalloonTipText = $message
    $balloon.BalloonTipTitle = $title
    $balloon.Visible = $true
    $balloon.ShowBalloonTip(10000)

    Start-Sleep -Seconds 12
    $balloon.Dispose()
}

#did I already notify you?
$lastNotification = ""

# Loop infinito (ctrl+c to stop)
while ($true) {
    $nowLocal = Get-Date
    $nowUTC = $nowLocal.ToUniversalTime()
    $nowSP = $nowUTC.AddHours(-3)

    $checkHour = $nowSP.Hour
    $checkMinute = $nowSP.Minute
    $currentTimeKey = "{0:00}:{1:00}" -f $checkHour, $checkMinute

    Write-Host "[LOG] Local: $($nowLocal.ToString("HH:mm")) | São Paulo/Brasilia: $($nowSP.ToString("HH:mm"))"

    $spawnMinute = 30
    $notificationMinute = ($spawnMinute - $notifyMinutesBeforeSpawn) % 60

    $shouldCheck = $checkMinute -eq $notificationMinute
    $isNewNotification = $currentTimeKey -ne $lastNotificationTime

    if ($shouldCheck -and $isNewNotification) {
        $targetHour = ($checkHour + [math]::Floor(($checkMinute + $notifyMinutesBeforeSpawn) / 60)) % 24
        $entry = $bossSchedule | Where-Object { $_.Hour -eq $targetHour }
        if ($entry) {
            $bossList = $entry.Bosses | ForEach-Object {
                if ($locations.ContainsKey($_)) { "$_ ($($locations[$_]))" } else { $_ }
            }
            $message = "Spawning in $notifyMinutesBeforeSpawn min: " + ($bossList -join ", ")
            Write-Host "[NOTIFY] $message"
            Show-ToastNotification -title "Boss Reminder" -message $message
            $lastNotificationTime = $currentTimeKey
        }
    }

    Start-Sleep -Seconds 5
}