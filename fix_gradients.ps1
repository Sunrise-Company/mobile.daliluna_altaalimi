$ErrorActionPreference = 'Continue'
$files = @(
    "lib\view\VideoLessonso.dart",
    "lib\view\pdfLessons.dart"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        try {
            $content = Get-Content $file -Raw
            $content = $content -replace "LinearGradientPainter", "LinearGradient"
            Set-Content -Path $file -Value $content -NoNewline
            Write-Host "✓ Fixed: $file"
        } catch {
            Write-Host "✗ Error: $file - $_"
        }
    }
}
