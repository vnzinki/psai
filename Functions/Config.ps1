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
    Provider = Read-Host "Please enter the provider name (OpenAI, Gemini)"
    OpenAI   = @{
      BaseUrl = Read-Host "Please enter the base URL for OpenAI"
      ApiKey  = Read-Host "Please enter your API key for OpenAI"
    }
  }
  $configContent | ConvertTo-Json | Set-Content -Path $Global:configPath
  Get-Config
}
