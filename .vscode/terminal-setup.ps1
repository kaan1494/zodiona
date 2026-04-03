# Bu script VS Code terminali acildiginda otomatik calisir.
# "flutter run" komutunu otomatik olarak dart_defines.json'daki
# degiskenleri ekleyerek calistirmak icin flutter komutunu override eder.

$definesPath = Join-Path $PSScriptRoot "..\dart_defines.json"

# Gercek flutter calistirilebilir dosyasini bul (Application tipinde, Function degil)
$_flutterExe = (Get-Command flutter -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1).Source
if (-not $_flutterExe) {
    # flutter.bat'i dogrudan dene
    $_flutterExe = (Get-Command flutter.bat -ErrorAction SilentlyContinue).Source
}
if (-not $_flutterExe) {
    Write-Warning "[Zodiona] flutter komutu PATH'te bulunamadi. flutter override yapilmadi."
} else {
    $script:_flutterExePath = $_flutterExe
    function flutter {
        $flutterArgs = $args
        if ($flutterArgs.Count -gt 0 -and $flutterArgs[0] -eq 'run') {
            if (Test-Path $definesPath) {
                $defines = Get-Content -Path $definesPath -Raw | ConvertFrom-Json
                $defineArgs = $defines.PSObject.Properties | ForEach-Object {
                    "--dart-define=$($_.Name)=$($_.Value)"
                }
                $remainingArgs = if ($flutterArgs.Count -gt 1) { $flutterArgs[1..($flutterArgs.Count - 1)] } else { @() }
                & $script:_flutterExePath run @defineArgs @remainingArgs
            } else {
                Write-Warning "dart_defines.json bulunamadi: $definesPath"
                & $script:_flutterExePath @flutterArgs
            }
        } else {
            & $script:_flutterExePath @flutterArgs
        }
    }
    Write-Host "[Zodiona] flutter run artik dart_defines.json parametrelerini otomatik kullanir. ($_flutterExe)" -ForegroundColor Cyan
}
