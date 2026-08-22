<#
    RESET_FIFA13_CONNECTION.ps1

    Puts this machine back to a clean state before connecting to the FIFA 13
    server, so a connection problem is a real one and not leftovers from a
    previous attempt.

    Run it in an ADMIN PowerShell (right-click Start > Terminal (Admin)), then:

        powershell -ExecutionPolicy Bypass -File .\RESET_FIFA13_CONNECTION.ps1

    It STOPS the game and our own helpers, and REPORTS anything else that is
    known to interfere. It does not uninstall anything and it does not touch
    your saves.
#>

param(
    # The server address you were given. When supplied, the script REPAIRS the
    # hosts file to point at it instead of merely clearing entries out.
    [string] $ServerAddress
)

$ErrorActionPreference = 'SilentlyContinue'
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
           ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

function Section([string]$text) {
    Write-Host ''
    Write-Host ('=== ' + $text + ' ===') -ForegroundColor Cyan
}

Write-Host 'FIFA 13 connection reset' -ForegroundColor White
if (-not $isAdmin) {
    Write-Host 'NOT RUNNING AS ADMIN - the hosts-file part will be skipped.' -ForegroundColor Yellow
    Write-Host 'Close this and re-open PowerShell as Administrator for the full reset.' -ForegroundColor Yellow
}

# ---------------------------------------------------------------- processes --
# The game itself, our launcher, and the credential helper the launcher injects.
# A half-dead game holds its network sockets open, which makes the server think
# the player is still connected long after the window has gone.
Section 'stopping the game and our helpers'
$ours = 'fifa13', 'PLAY FIFA 13', 'Fut13GuestLauncher', 'frida-inject', 'Fut13Local.Bridge'
foreach ($name in $ours) {
    $procs = @(Get-Process -Name $name)
    if ($procs.Count -gt 0) {
        $procs | Stop-Process -Force
        Write-Host ('  stopped ' + $name + ' (' + $procs.Count + ')') -ForegroundColor Green
    } else {
        Write-Host ('  not running: ' + $name) -ForegroundColor DarkGray
    }
}

# --------------------------------------------------------------------- EA --
# EA's own software must not be running. The EA app and Origin both try to
# manage FIFA 13 themselves: they inject an overlay, they can re-point the game
# at EA's real (dead) servers, and their background services hold handles on the
# game directory. None of it is needed here - our launcher signs you in on its
# own and talks to a private server, so EA's client has no part to play.
Section 'stopping EA / Origin software'
$eaProcs = @(
    'EADesktop', 'EABackgroundService', 'EACefSubProcess', 'EALaunchHelper',
    'EAConnect_microsoft', 'EALocalHostSvc', 'EACoreServer', 'EASteamProxy',
    'Origin', 'OriginWebHelperService', 'OriginClientService', 'OriginER',
    'EAAntiCheat.GameServiceLauncher', 'EasyAntiCheat',
    'fifaconfig', 'fifasetup'
)
$killedEa = $false
foreach ($name in $eaProcs) {
    $procs = @(Get-Process -Name $name)
    if ($procs.Count -gt 0) {
        $procs | Stop-Process -Force
        Write-Host ('  stopped ' + $name + ' (' + $procs.Count + ')') -ForegroundColor Green
        $killedEa = $true
    }
}

# Safety net. The list above is exact names, and EA renames things: the old
# client is Origin.exe, the current one is EADesktop.exe, and installers ship
# helpers under names nobody has seen before. Sweep for anything whose process
# name or company looks like EA and has not already been dealt with.
foreach ($p in Get-Process) {
    if ($p.ProcessName -match '^(EA|Origin)' -or $p.Company -match 'Electronic Arts') {
        # our own game and launcher are handled elsewhere; do not double-report
        if ($p.ProcessName -notmatch '^(fifa13|PLAY FIFA 13)$') {
            Stop-Process -Id $p.Id -Force
            Write-Host ('  stopped ' + $p.ProcessName + ' (matched EA sweep)') -ForegroundColor Green
            $killedEa = $true
        }
    }
}

if (-not $killedEa) { Write-Host '  no EA software running' -ForegroundColor DarkGray }

# The services restart their processes if left running, so stop those too.
Section 'stopping EA background services'
$eaServices = 'EABackgroundService', 'Origin Client Service', 'OriginWebHelperService',
              'EasyAntiCheat', 'EAAntiCheat.GameService', 'EALocalHostSvc'
$stoppedSvc = $false
foreach ($svc in $eaServices) {
    $s = Get-Service -Name $svc
    if ($s -and $s.Status -eq 'Running') {
        Stop-Service -Name $svc -Force
        Write-Host ('  stopped service: ' + $svc) -ForegroundColor Green
        $stoppedSvc = $true
    }
}
if (-not $stoppedSvc) { Write-Host '  none running' -ForegroundColor DarkGray }

# EA's client is persistent - it comes back on its own and on every reboot.
$eaAutoStart = @(Get-CimInstance Win32_StartupCommand |
                 Where-Object { $_.Command -match 'EADesktop|Origin|EABackground' })
if ($eaAutoStart.Count -gt 0) {
    Write-Host '  NOTE: EA software is set to start with Windows, so it will come back.' -ForegroundColor Yellow
    Write-Host '  If the game keeps failing, turn it off in Task Manager > Startup apps.' -ForegroundColor DarkGray
}

# Anyone who once hosted the server locally may still have the stack running.
# Those windows keep ports 8099/10092/42127 bound, and the game will happily
# talk to THEM instead of the real server - which looks exactly like the real
# server being broken.
Section 'stopping a leftover LOCAL server stack'
$stackFound = $false
foreach ($p in Get-CimInstance Win32_Process -Filter "Name='powershell.exe' or Name='pwsh.exe' or Name='python.exe'") {
    if ($p.CommandLine -and $p.CommandLine -match 'fut13|FIFA-13-Local|RUN_LOCAL_FUT13|rs4-server') {
        if ($p.ProcessId -ne $PID) {
            Stop-Process -Id $p.ProcessId -Force
            Write-Host ('  stopped pid ' + $p.ProcessId + ' (' + $p.Name + ') - local stack') -ForegroundColor Green
            $stackFound = $true
        }
    }
}
if (-not $stackFound) { Write-Host '  none found' -ForegroundColor DarkGray }

Section 'anything still listening on the server ports'
$busy = Get-NetTCPConnection -State Listen |
        Where-Object { $_.LocalPort -in 8099, 8080, 10092, 42127, 42128 }
if ($busy) {
    foreach ($b in $busy) {
        $owner = (Get-Process -Id $b.OwningProcess).ProcessName
        Write-Host ('  PORT ' + $b.LocalPort + ' still held by ' + $owner + ' (pid ' + $b.OwningProcess + ')') -ForegroundColor Yellow
    }
    Write-Host '  ^ these must be gone, or the game connects to this PC instead of the server.' -ForegroundColor Yellow
} else {
    Write-Host '  clear' -ForegroundColor Green
}

# -------------------------------------------------------------------- hosts --
# The single most common cause of "The EA servers are not available at this
# time" on a machine that used to run the server locally: a leftover line
# sending gosredirector.ea.com to 127.0.0.1. Windows uses the FIRST match in the
# file, so a stale local line beats the launcher's own entry further down.
Section 'hosts file'

# THIS SCRIPT NO LONGER EDITS THE HOSTS FILE BY DEFAULT, and that is deliberate.
#
# It used to delete every EA redirect line and trust the launcher to write a
# correct one next time. That assumption is false for anyone who starts the game
# another way - through Steam, or fifa13.exe directly - and on 22 Aug 2026 it
# stranded two machines: with no redirect, gosredirector.ea.com resolves to EA's
# REAL server, dead for years, and the game reports "The EA servers are not
# available at this time." True, and completely misleading.
#
# The launcher repairs this correctly on every run. So the job here is to REPORT
# what Windows would actually use, and to repair only when given the address to
# repair TO.
$hostsPath = Join-Path $env:WINDIR 'System32\drivers\etc\hosts'
$names = 'gosredirector.ea.com', 'content.lt.easfc.ea.com'

# Work out the WINNING line per name. Windows uses the first match, so a stale
# entry above a correct one decides everything - printing every match without
# saying which one wins is how this stayed invisible.
function Get-WinningAddress([string[]]$fileLines, [string]$name) {
    foreach ($raw in $fileLines) {
        $l = $raw
        $hash = $l.IndexOf('#')
        if ($hash -ge 0) { $l = $l.Substring(0, $hash) }
        $parts = $l -split '\s+' | Where-Object { $_ -ne '' }
        if ($parts.Count -lt 2) { continue }
        for ($i = 1; $i -lt $parts.Count; $i++) {
            if ($parts[$i] -ieq $name) { return $parts[0] }
        }
    }
    return $null
}

$lines = @(Get-Content $hostsPath)
foreach ($n in $names) {
    $winner = Get-WinningAddress $lines $n
    if ($null -eq $winner) {
        Write-Host ("  " + $n + " -> NOT REDIRECTED (the game will try EA's real, dead servers)") -ForegroundColor Yellow
    } elseif ($ServerAddress -and $winner -ne $ServerAddress) {
        Write-Host ("  " + $n + " -> " + $winner + "  WRONG, expected " + $ServerAddress) -ForegroundColor Red
    } else {
        Write-Host ("  " + $n + " -> " + $winner) -ForegroundColor Green
    }
}

if (-not $ServerAddress) {
    Write-Host ''
    Write-Host '  Not changing anything. The launcher fixes this itself on every run.' -ForegroundColor DarkGray
    Write-Host '  To repair it here instead, re-run with the address you were given:' -ForegroundColor Cyan
    Write-Host '     .\RESET_FIFA13_CONNECTION.ps1 -ServerAddress <address>' -ForegroundColor Cyan
} elseif (-not $isAdmin) {
    Write-Host '  Cannot repair - not running as administrator.' -ForegroundColor Yellow
} else {
    $backup = Join-Path $env:TEMP ('hosts-backup-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.txt')
    Copy-Item $hostsPath $backup -Force

    # MARKER-BASED, like the launcher: rewrite only our own block, drop any other
    # line mapping these names, and ALWAYS write the correct entries back in the
    # same pass so the file is never left without them.
    $begin = '# FIFA13 FUT LAN GUEST BEGIN'
    $end   = '# FIFA13 FUT LAN GUEST END'
    $kept = New-Object System.Collections.Generic.List[string]
    $inside = $false
    foreach ($raw in $lines) {
        $t = $raw.Trim()
        if ($t -eq $begin) { $inside = $true; continue }
        if ($t -eq $end)   { $inside = $false; continue }
        if ($inside) { continue }

        $l = $raw
        $hash = $l.IndexOf('#')
        if ($hash -ge 0) { $l = $l.Substring(0, $hash) }
        $parts = $l -split '\s+' | Where-Object { $_ -ne '' }
        $maps = $false
        if ($parts.Count -ge 2) {
            for ($i = 1; $i -lt $parts.Count; $i++) {
                foreach ($n in $names) { if ($parts[$i] -ieq $n) { $maps = $true } }
            }
        }
        if (-not $maps) { $kept.Add($raw) }
    }
    $kept.Add($begin)
    foreach ($n in $names) { $kept.Add($ServerAddress + ' ' + $n) }
    $kept.Add($end)

    # NEVER TRUNCATE THE HOSTS FILE IN PLACE. Set-Content opens the file for
    # writing - emptying it - and only then writes, so a failure at that moment
    # leaves a ZERO-BYTE hosts file. That is not theoretical: it happened on
    # 22 Aug 2026, with "Stream was not readable", because something else held a
    # handle on the file. On a player's PC that is routine - antivirus scans
    # hosts constantly. Write a temp file and swap it in only once complete.
    $tmp = $hostsPath + '.fut13new'
    Set-Content -Path $tmp -Value $kept -Encoding ASCII
    $swapped = $false
    for ($try = 0; $try -lt 5 -and -not $swapped; $try++) {
        try {
            [System.IO.File]::Replace($tmp, $hostsPath, $null)
            $swapped = $true
        } catch {
            Start-Sleep -Milliseconds (150 * ($try + 1))
        }
    }
    if (-not $swapped) {
        Write-Host '  Could not update the hosts file - something is holding it open,' -ForegroundColor Red
        Write-Host '  usually antivirus. Your hosts file has NOT been changed.' -ForegroundColor Red
        Remove-Item $tmp -Force -ErrorAction SilentlyContinue
    }

    # VERIFY - but only if the swap actually happened. Claiming REPAIRED after a
    # failed write would be true only by accident: the check passes whenever the
    # file was ALREADY correct, which is exactly when the operator least needs a
    # false reassurance.
    if ($swapped) {
    $after = @(Get-Content $hostsPath)
    $bad = @()
    foreach ($n in $names) {
        $w = Get-WinningAddress $after $n
        if ($w -ne $ServerAddress) { $bad += ($n + ' -> ' + $w) }
    }
    if ($bad.Count -gt 0) {
        Write-Host ('  REPAIR FAILED: ' + ($bad -join '; ')) -ForegroundColor Red
        Write-Host ('  restoring from ' + $backup) -ForegroundColor Yellow
        Copy-Item $backup $hostsPath -Force
    } else {
        Write-Host ('  REPAIRED - both names now resolve to ' + $ServerAddress) -ForegroundColor Green
        Write-Host ('  backup: ' + $backup) -ForegroundColor DarkGray
    }
    }
}

Section 'flushing DNS'
ipconfig /flushdns | Out-Null
Write-Host '  done' -ForegroundColor Green

# ------------------------------------------------------------- interference --
# Reported, NOT killed. These belong to the person using this PC and stopping
# them silently would be rude - but each one is a real suspect, so they need to
# be visible.
Section 'things known to break the game (please close these yourself)'
$suspects = @(
    @{ Match = 'nordvpn';        Why = 'VPN - changes your apparent IP, which the match relay uses to identify you' },
    @{ Match = 'expressvpn';     Why = 'VPN - same problem' },
    @{ Match = 'protonvpn';      Why = 'VPN - same problem' },
    @{ Match = 'wireguard|openvpn'; Why = 'VPN tunnel - same problem' },
    @{ Match = 'GameBar|XboxGame'; Why = 'Xbox Game Bar overlay - injects into the game' },
    @{ Match = 'obs64|obs32';    Why = 'OBS - capture hook injects into the game' },
    @{ Match = 'Discord';        Why = 'Discord overlay injects into the game (the app is fine, the OVERLAY is not)' },
    @{ Match = 'RTSS|RivaTuner|MSIAfterburner'; Why = 'FPS overlay - injects into the game' },
    @{ Match = 'GeForceNOW|NVIDIA Share|nvsphelper'; Why = 'GeForce Experience overlay - injects into the game' }
)
$anySuspect = $false
foreach ($s in $suspects) {
    $found = @(Get-Process | Where-Object { $_.ProcessName -match $s.Match })
    if ($found.Count -gt 0) {
        $anySuspect = $true
        Write-Host ('  RUNNING: ' + (($found | Select-Object -ExpandProperty ProcessName -Unique) -join ', ')) -ForegroundColor Red
        Write-Host ('           ' + $s.Why) -ForegroundColor DarkGray
    }
}
if (-not $anySuspect) { Write-Host '  none detected' -ForegroundColor Green }

Section 'result'
Write-Host 'This PC is reset. Now:' -ForegroundColor White
Write-Host '  1. Close anything listed in RED above (especially a VPN).'
Write-Host '  2. Run "PLAY FIFA 13.exe" again.'
Write-Host '  3. Enter the server address you were given and press Play.'
Write-Host ''
Write-Host 'If it still fails, copy this whole window and send it back.' -ForegroundColor White
