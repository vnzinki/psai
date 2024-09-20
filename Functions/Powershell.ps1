# Use SendKeys to paste to the current line in the console
Add-Type -AssemblyName System.Windows.Forms
$DebugPreference = 'SilentContinue'

function Add-ToInputPrompt {
  <#
    Paste the given text to the current line in the console
  #>
  param (
    [string]$TextToAdd
  )

  $oldClipboard = Get-Clipboard

  Set-Clipboard -Value $TextToAdd
  [System.Windows.Forms.SendKeys]::SendWait("^v")

  Set-Clipboard -Value $oldClipboard
}

function PsAI {
  <#
    Suggest a command completion based on the given prompt
    and the current platform, OS, powershell version, and
    powershell edition
  #>
  param (
    [string]$Prompt
  )

  if (-not $Prompt -or $Prompt.Trim() -eq '') {
    Write-Error "Prompt should not be empty or blank"
    return
  }

  Get-Config

  $Context = "$($PSVersionTable.Platform) $($PSVersionTable.OS) Powershell $($PSVersionTable.PSEdition) $($PSVersionTable.PSVersion)"

  switch ($Global:Config.Provider) {
    "ChatGPT" {
      Add-ToInputPrompt $(ChatGPTGetCompletion $Context $Prompt)
    }
    Default {}
  }
}

if (-not (Get-Command -Name Set-PSReadlineKeyHandler -ErrorAction SilentlyContinue)) {
  Write-Warning "The module PSReadline is required for binding the key. Please install it with 'Install-Module -Name PSReadline -AllowPrerelease'"
  return
}
else {
  Write-Host "PsAI with PSReadline actived! You can use hot key Ctrl+x to suggest command using AI"
  Get-Config
}

# Set up a key binding for Ctrl+x to suggest command completions
Set-PSReadlineKeyHandler -Chord Ctrl+x `
  -BriefDescription "Suggest command using AI" `
  -ScriptBlock {
  <#
    Get the current line in the console
    and pass it to PsAI
  #>
  $currentInput = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$currentInput, [ref]$null)
  [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
  PsAI $currentInput
}
