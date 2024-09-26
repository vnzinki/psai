function GroqGetCompletion ([string] $Context, [string] $Prompt) {
  $Body = @{
    messages = @(
      @{role = "system"; content = "You are a $Context, please help me complete the following command, you should only output the completed command in one line with minimal dependency, no need to include any other explanation. Do not put completed command in a code block." },
      @{role = "user"; content = "$Prompt" }
    )
    model    = $Global:Config.Groq.Model
  } | ConvertTo-Json

  $Headers = @{
    "Authorization"  = "Bearer $($Global:Config.Groq.ApiKey)"
    "Content-Type" = "application/json"
  }

  Write-Debug "Headers: $($Headers | ConvertTo-Json)"
  Write-Debug "Request: $Body"

  try {
    $Response = Invoke-WebRequest -Uri "https://api.groq.com/openai/v1/chat/completions" -Method Post -Body $body -Headers $Headers -TimeoutSec 10
  }
  catch {
    Write-Host "Request failed: $($_.Exception.Message)" -ForegroundColor Red
    exit
  }

  Write-Debug "Response: $($Response.Content)"
  $ResponseObject = $Response.Content | ConvertFrom-Json
  return $ResponseObject.choices[0].message.content
}
