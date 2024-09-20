Import-Module "$PSScriptRoot/../PsAI.psd1" -Force

Describe "ChatGPT" {
  It "ChatGPT API Endpoint" {
    $ApiKey = $Global:Config.ChatGPT.ApiKey
    $Global:Config.ChatGPT.ApiKey = "WRONG_API_KEY"

    ChatGPTGetCompletion("find process running port 4200 then kill") | Should -Be "Error: Invalid API Key"

    $Global:Config.ChatGPT.ApiKey = $ApiKey
  }
}
