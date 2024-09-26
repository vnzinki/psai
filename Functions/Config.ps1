$ConfigPath = "$env:USERPROFILE\.psai"

$DefualtConfig = @{
  Provider = "Groq"
  OpenAI = @{
    ApiKey = ""
    Model = "gpt-3.5-turbo"
  }
  Gemini = @{
    ApiKey = ""
    Model = "gemini-1.5-flash-latest"
  }
  Groq = @{
    ApiKey = ""
    Model = "llama3-groq-70b-8192-tool-use-preview"
  }
}

function Get-Config {
  if (-not (Test-Path -Path $ConfigPath)) {
    $Global:Config = $DefualtConfig
    return
  }

  try {
    $SavedConfig = Get-Content -Path $ConfigPath -Raw | ConvertFrom-Json
  }
  catch {
    Write-Warning "Failed to parse the config file: $($_.Exception.Message). Try remove config file at $($ConfigPath) and try again."
  }

  if (-not $SavedConfig) {
    $Global:Config = $DefualtConfig
    return
  }

  $Global:Config = $SavedConfig

  Write-Debug "Loaded config from $ConfigPath using Provider: $($Global:Config.Provider)"
}

function Set-Config {
  $Providers = @("OpenAI", "Groq", "Gemini")
  $Choice = 0

  while ($Choice -lt 1 -or $Choice -gt $Providers.Length) {
    Write-Host "Choose a provider:"
    for ($i = 0; $i -lt $Providers.Length; $i++) {
      Write-Host "  $($i+1)) $($Providers[$i])"
    }
    $Choice = Read-Host "Enter the number of your choice"
    try {
      $Choice = [int]::Parse($Choice)
    }
    catch {
      Write-Host "Invalid input" -ForegroundColor Red
      $Choice = 0
    }
  }

  $Global:Config.Provider = $Providers[$Choice - 1]

  $InputApiKey = Read-Host "Enter your $($Global:Config.Provider) API key"

  if ($InputApiKey) {
    $Global:Config.$($Global:Config.Provider).ApiKey = $InputApiKey
  }

  $Global:Config | ConvertTo-Json | Set-Content -Path $ConfigPath

}
