# Use SendKeys to paste to the current line in the console
Add-Type -AssemblyName System.Windows.Forms

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
  if (-not $Global:Config) {
    Set-Config
  }

  $Context = "Powershell $($PSVersionTable.PSEdition) $($PSVersionTable.PSVersion) expert working on $($PSVersionTable.Platform) $($PSVersionTable.OS)"

  switch ($Global:Config.Provider) {
    "OpenAI" {
      Add-ToInputPrompt $(OpenAIGetCompletion $Context $Prompt)
    }
    Default {}
  }
}

# Load config
Get-Config
if (-not $Global:Config) {
  Set-Config
}

if (-not (Get-Command -Name Set-PSReadlineKeyHandler -ErrorAction SilentlyContinue)) {
  Write-Warning "The module PSReadline is required for binding the key. Please install it with 'Install-Module -Name PSReadline -AllowPrerelease'"
}
else {
  Write-Host "PsAI with PSReadline actived! You can use hot key Ctrl+x to suggest command using AI"
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
