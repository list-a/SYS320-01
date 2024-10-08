. (Join-Path $PSScriptRoot Untitled7.ps1)
. (Join-Path $PSScriptRoot Apache-Logs.ps1)
. (Join-Path $PSScriptRoot menu.ps1)
clear

$Prompt  = "Please choose your operation:`n"
$Prompt += "1 - List apache logs`n"
$Prompt += "2 - List last failed logons`n"
$Prompt += "3 - display at risk users`n"
$Prompt += "4 - start chrome`n"
$Prompt += "5 - exit`n"

$operation = $true

while($operation){

    Write-Host $Prompt | Out-String
    $choice = Read-Host
    

    if($choice -eq 1){
    $cout | Format-Table -AutoSize -Wrap

    }

    if($choice -eq 2){
    getFailedLogins
    }

    if($choice -eq 4){
    Start-Process chrome.exe 'champlain.edu'
    }

    if($choice -eq 5){
    exit
    $operation = false
    }
    }
