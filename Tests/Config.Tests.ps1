Import-Module "$PSScriptRoot/../PsAI.psd1" -Force

Describe "Config" {
  It "should load config" {
    $configContent = @{
      Provider = "OpenAI"
      OpenAI  = @{
        BaseUrl = "https://api.groq.com/openai/v1"
        ApiKey  = "YOUR_API_KEY"
        Model   = "llama3-8b-8192"
      }
    }
    $configContent | ConvertTo-Json | Set-Content -Path $Global:configPath

    Get-Config

    $Global:Config | Should -Not -BeNullOrEmpty
  }
}
