$Global:configPath = "$env:USERPROFILE\.psai"

function Get-Config {
  if (Test-Path -Path $configPath) {
    try {
      $configContent = Get-Content -Path $Global:configPath -Raw | ConvertFrom-Json

      $Global:Config = $configContent
      Write-Debug "Loaded config from $Global:configPath using Provider: $($Global:Config.Provider)"
    }
    catch {
      Write-Warning "Failed to parse the config file: $_"
      Remove-Item -Path $Global:configPath
    }
  }
  else {
    Write-Warning "Config file not found at $Global:configPath. Creating a new one."
    Set-Config
    return $null
  }
}

function Set-Config {
  $configContent = @{
    Provider = Read-Host "Provider name (currently only suport OpenAI)" -DefaultValue "OpenAI"
    OpenAI   = @{
      BaseUrl = Read-Host "Base URL for OpenAI" -DefaultValue "https://api.openai.com/v1"
      ApiKey  = Read-Host "API key for OpenAI"
      Model  = Read-Host "Model for OpenAI" -DefaultValue "gpt-3.5-turbo"
    }
  }
  $configContent | ConvertTo-Json | Set-Content -Path $Global:configPath
  Get-Config
}
