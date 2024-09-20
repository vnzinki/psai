$Global:configPath = "$env:USERPROFILE\.psai"

function Get-Config {
  try {
    if (-not (Test-Path -Path $configPath)) {
      throw [System.IO.FileNotFoundException]::new("Config file not found: $configPath")
    }

    $Global:Config = Get-Content -Path $Global:configPath -Raw | ConvertFrom-Json

    Write-Debug "Loaded config from $Global:configPath using Provider: $($Global:Config.Provider)"
  }
  catch {
    Write-Warning "Failed to parse the config file: $($_.Exception.Message)"
  }
}

function Set-Config {
  $InputConfig = @{
    Provider = "OpenAI"
    OpenAI = @{
      BaseUrl = ""
      ApiKey = ""
      Model = ""
    }
  }

  # $InputConfig.Provider = Read-Host "Provider name (currently only support OpenAI)"
  $InputConfig.OpenAI.BaseUrl = Read-Host "Base URL for OpenAI (default: https://api.groq.com/openai/v1)"
  $InputConfig.OpenAI.Model = Read-Host "Model for OpenAI (default: llama3-groq-70b-8192-tool-use-preview)"
  $InputConfig.OpenAI.ApiKey = Read-Host "API key for OpenAI"

  # Apply default values
  if ($InputConfig.OpenAI.BaseUrl -eq "") {
    $InputConfig.OpenAI.BaseUrl = "https://api.groq.com/openai/v1"
  }

  if ($InputConfig.OpenAI.Model -eq "") {
    $InputConfig.OpenAI.Model = "llama3-groq-70b-8192-tool-use-preview"
  }

  if ($InputConfig.OpenAI.ApiKey -eq "") {
    Write-Host "API key cannot be empty" -ForegroundColor Red
    return
  }

  $InputConfig | ConvertTo-Json | Set-Content -Path $Global:configPath
}
