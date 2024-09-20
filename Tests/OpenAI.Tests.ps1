Import-Module "$PSScriptRoot/../PsAI.psd1" -Force

Describe "OpenAI" {
  It "OpenAI API Endpoint" {
    $ApiKey = $Global:Config.OpenAI.ApiKey
    $Global:Config.OpenAI.ApiKey = "WRONG_API_KEY"

    OpenAIGetCompletion("find process running port 4200 then kill") | Should -Be "Error: Invalid API Key"

    $Global:Config.OpenAI.ApiKey = $ApiKey
  }
}
