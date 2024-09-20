Import-Module "$PSScriptRoot/../PsAI.psd1" -Force

Describe "Powershell" {
  It "Example Command" {
    PsAI("find process running port 4200 then kill") | Should -BeLike "*Port*4200*Stop-Process*"
  }
}
