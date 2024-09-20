$DebugPreference = 'SilentContinue'
Get-ChildItem -Path "$PSScriptRoot\Functions\*.ps1" | ForEach-Object { . $_.FullName }
