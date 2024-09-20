<h1 align="center">PsAI</h1>

<p align="center">
  A User-Friendly Module for PowerShell command suggestion using AI. <br/>
  Write what you want, press hot key `ctrl+x` to get the command.
</p>

## Todo
- [x] Add option to set AI model
- [x] Add option to set API key
- [x] Add option to set base URL
- [ ] Add Gemini support
- [ ] Better config initialization
- [ ] Use last error to enrich the suggestion
- [ ] Publish-Module


## How do I install it?

Clone from source:
```
git clone https://github.com/vnzinki/psai.git (Join-Path -Path $env:USERPROFILE -ChildPath "Documents\PowerShell\Modules\PsAI")
```

Then auto Import Module by add line to your profile:
```
Add-Content -Path $PROFILE -Value 'if (Get-Module -Name PsAI -ListAvailable) { Import-Module PsAI }'

```

## How do I use it?
To use PsAI, simply type a description of what you want to do, and then press the hot key `ctrl+x`. PsAI will then fill the console with the command to accomplish what you described.


## Config

Config file `.psai` is stored in `$env:USERPROFILE\.psai`
When you first run PsAI, it will prompt you to create a config file.

```
{
  "Provider": "ChatGPT", # TODO: Add support for Gemini
  "ChatGPT": {
    "Model": "gpt-4o",
    "ApiKey": "YOUR_API_KEY",
    "BaseUrl": "https://api.openai.com/v1" # Your can use https://api.groq.com/openai/v1
  }
}

```

## Troubleshooting
