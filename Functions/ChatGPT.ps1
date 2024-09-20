function OpenAIGetCompletion ([string] $Context, [string] $Prompt) {
  $Body = @{
    messages = @(
      @{role = "system"; content = "You are a $Context expert, please help me complete the following command, you should only output the completed command with minimal dependency, no need to include any other explanation. Do not put completed command in a code block." },
      @{role = "user"; content = "$Prompt" }
    )
    model    = $Global:Config.OpenAI.Model
  } | ConvertTo-Json

  $Headers = @{
    Authorization  = "Bearer $($Global:Config.OpenAI.ApiKey)"
    "Content-Type" = "application/json"
  }

  Write-Debug "Request: $Body"

  try {
    $Response = Invoke-WebRequest -Uri "$($Global:Config.OpenAI.BaseUrl)/chat/completions" -Method Post -Body $body -Headers $Headers
  }
  catch {
    $ApiError = $($_ | ConvertFrom-Json)
    return "Error: $($ApiError.error.message)"
  }

  $ResponseObject = $Response.Content | ConvertFrom-Json
  return $ResponseObject.choices[0].message.content
}
