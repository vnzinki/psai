function GeminiGetCompletion ([string] $Context, [string] $Prompt) {
  $Body = @{
    system_instruction = @{
      parts = @{
        text = "You are a $Context, please help me complete the following command, you should only output the completed command in one line with minimal dependency, no need to include any other explanation. Command is one line only and not wrap in code block."
      }
    }
    contents           = @{
      parts = @{
        text = $Prompt
      }
    }
  } | ConvertTo-Json

  $Headers = @{
    "Content-Type" = "application/json"
  }

  Write-Debug "Uri: https://generativelanguage.googleapis.com/v1beta/models/$($Global:Config.Gemini.Model):generateContent?key=$($Global:Config.Gemini.ApiKey)"
  Write-Debug "Request: $Body"

  try {
    $Response = Invoke-WebRequest -Uri "https://generativelanguage.googleapis.com/v1beta/models/$($Global:Config.Gemini.Model):generateContent?key=$($Global:Config.Gemini.ApiKey)" -Method Post -Headers $Headers -Body $Body -TimeoutSec 10
  }
  catch {
    Write-Host "Request failed: $($_.Exception.Message)" -ForegroundColor Red
    exit
  }

  Write-Debug "Response: $($Response.Content)"
  $ResponseObject = $Response.Content | ConvertFrom-Json
  return $ResponseObject.candidates[0].content.parts[0].text
}
