# PowerShell Script to Build Flutter APK and Send to Telegram

# 1. Load or Prompt for Credentials
$envFile = "$PSScriptRoot\..\.env"
if (Test-Path $envFile) {
    Write-Host "Loading credentials from .env..." -ForegroundColor Cyan
    Get-Content $envFile | ForEach-Object {
        if ($_ -match "^(.*?)=(.*)$") {
            Set-Variable -Name $matches[1] -Value $matches[2] -Scope Script
        }
    }
}

if (-not $TELEGRAM_BOT_TOKEN) {
    $TELEGRAM_BOT_TOKEN = Read-Host "Enter your Telegram Bot Token"
    Add-Content -Path $envFile -Value "TELEGRAM_BOT_TOKEN=$TELEGRAM_BOT_TOKEN"
}

if (-not $TELEGRAM_CHAT_ID) {
    $TELEGRAM_CHAT_ID = Read-Host "Enter your Telegram Chat ID"
    Add-Content -Path $envFile -Value "TELEGRAM_CHAT_ID=$TELEGRAM_CHAT_ID"
}

# 2. Build APK
Write-Host "Building Flutter APK (Split per ABI)..." -ForegroundColor Yellow
flutter build apk --release --split-per-abi

if ($LASTEXITCODE -ne 0) {
    Write-Error "Build failed!"
    exit 1
}

$apkDir = "$PSScriptRoot\..\build\app\outputs\flutter-apk"
$apks = Get-ChildItem -Path $apkDir -Filter "*-release.apk" | Where-Object { $_.Name -ne "app-release.apk" }

if ($apks.Count -eq 0) {
    Write-Error "No APKs found in $apkDir"
    exit 1
}

# 3. Get App Details
$pubspecPath = "$PSScriptRoot\..\pubspec.yaml"
$appName = "Unknown App"
$appVersion = "Unknown Version"

if (Test-Path $pubspecPath) {
    $pubspecContent = Get-Content $pubspecPath -Raw
    if ($pubspecContent -match "name:\s*(.+)") { $appName = $matches[1].Trim() }
    if ($pubspecContent -match "version:\s*(.+)") { $appVersion = $matches[1].Trim() }
}

# 4. Send to Telegram (PowerShell 5.1 Compatible)
Add-Type -AssemblyName 'System.Net.Http'

foreach ($apk in $apks) {
    Write-Host "Sending $($apk.Name)..." -ForegroundColor Cyan
    
    $abiDescription = switch -Wildcard ($apk.Name) {
        "*arm64-v8a*" { "Modern Phones (Most Common)" }
        "*armeabi-v7a*" { "Older Phones (32-bit)" }
        "*x86_64*" { "Emulators / PC" }
        Default { "Universal" }
    }

    $url = "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendDocument"
    # Wrap values in backticks (`) to avoid Markdown errors with underscores. 
    # In PowerShell, a literal backtick is escaped as ``
    $caption = "*New Build Deployed!*`n`nApp: ``$appName`` `nVersion: ``$appVersion`` `nFile: ``$($apk.Name)`` `nType: $abiDescription `nDate: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

    $client = New-Object System.Net.Http.HttpClient
    $client.Timeout = [TimeSpan]::FromMinutes(10) # Increase timeout to 10 minutes

    $content = New-Object System.Net.Http.MultipartFormDataContent

    try {
        $fileStream = [System.IO.File]::OpenRead($apk.FullName)
        $fileContent = New-Object System.Net.Http.StreamContent($fileStream)
        $content.Add($fileContent, "document", $apk.Name)

        $content.Add((New-Object System.Net.Http.StringContent($TELEGRAM_CHAT_ID)), "chat_id")
        $content.Add((New-Object System.Net.Http.StringContent($caption)), "caption")
        $content.Add((New-Object System.Net.Http.StringContent("Markdown")), "parse_mode")

        $response = $client.PostAsync($url, $content).Result
        
        if ($response.IsSuccessStatusCode) {
            Write-Host "SUCCESS: Sent $($apk.Name)!" -ForegroundColor Green
        } else {
            $status = if ($response.StatusCode) { $response.StatusCode } else { "Unknown" }
            Write-Host "FAILED to send $($apk.Name): $status" -ForegroundColor Red
            
            if ($response.Content) {
                $errorBody = $response.Content.ReadAsStringAsync().Result
                Write-Host "Server Response: $errorBody" -ForegroundColor Red
            }
        }
    } catch {
        Write-Error "Error sending to Telegram: $_"
    } finally {
        if ($fileStream) { $fileStream.Close() }
        if ($client) { $client.Dispose() }
        if ($content) { $content.Dispose() }
    }
}
