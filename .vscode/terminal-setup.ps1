# Bu script VS Code terminali acildiginda otomatik calisir.
# "flutter run" komutunu otomatik olarak dart_defines.json'daki
# degiskenleri ekleyerek calistirmak icin flutter komutunu override eder.

$definesPath = Join-Path $PSScriptRoot "..\dart_defines.json"

function flutter {
    $flutterArgs = $args
    if ($flutterArgs.Count -gt 0 -and $flutterArgs[0] -eq 'run') {
        if (Test-Path $definesPath) {
            $defines = Get-Content -Path $definesPath -Raw | ConvertFrom-Json
            $defineArgs = $defines.PSObject.Properties | ForEach-Object {
                "--dart-define=$($_.Name)=$($_.Value)"
            }
            $remainingArgs = if ($flutterArgs.Count -gt 1) { $flutterArgs[1..($flutterArgs.Count - 1)] } else { @() }
            & flutter.exe run @defineArgs @remainingArgs
        } else {
            Write-Warning "dart_defines.json bulunamadi: $definesPath"
            & flutter.exe @flutterArgs
        }
    } else {
        & flutter.exe @flutterArgs
    }
}

Write-Host "[Zodiona] flutter run artik dart_defines.json parametrelerini otomatik kullanir." -ForegroundColor Cyan
