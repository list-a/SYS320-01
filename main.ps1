. (Join-Path $PSScriptRoot Users.ps1)
. (Join-Path $PSScriptRoot Event-Logs.ps1)
clear

$Prompt  = "Please choose your operation:`n"
$Prompt += "1 - List Enabled Users`n"
$Prompt += "2 - List Disabled Users`n"
$Prompt += "3 - Create a User`n"
$Prompt += "4 - Remove a User`n"
$Prompt += "5 - Enable a User`n"
$Prompt += "6 - Disable a User`n"
$Prompt += "7 - Get Log-In Logs`n"
$Prompt += "8 - Get Failed Log-In Logs`n"
$Prompt += "9 - Exit)`n"

$operation = $true

while($operation){

    Write-Host $Prompt | Out-String
    $choice = Read-Host

    if($choice -eq 9){
        Write-Host "Goodbye" | Out-String
        exit
        $operation = $false 
    }

    if($choice -eq 1){
        $enabledUsers = getEnabledUsers
        Write-Host ($enabledUsers | Format-Table | Out-String)
    }

    elseif($choice -eq 2){
        $notEnabledUsers = getNotEnabledUsers
        Write-Host ($notEnabledUsers | Format-Table | Out-String)
    }

    # Create a user
    elseif($choice -eq 3){

        $name = Read-Host -Prompt "enter username"
        $password = Read-Host -AsSecureString -Prompt "new password"

        $usercheck = checkUser $name
        if(-not $usercheck)
        {
        #as secure string
            $pass = Read-Host -AsSecureString -Prompt "enter password for new user"

            $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass)
            $digest = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
            $checkPassword = checkPassword $digest
            if ($checkPassword){
                createAUser $name $password
                Write-Host "new user: $name is now active" | Out-String
            }

            else {
                Write-Host "password incorrect" | Out-String
            }
        }
        else {
            Write-Host "$name already exists" | Out-String
        }
    }

    # Remove a user
    elseif($choice -eq 4){
        $name = Read-Host -Prompt "Please enter the username for the user to be removed"
        if (-not (checkUser $name)) {
            Write-Host "$name does not exist!" | Out-String
        }

        removeAUser $name
        Write-Host "User: $name Removed." | Out-String
    }

    # Enable a user
    elseif($choice -eq 5){
        $name = Read-Host -Prompt "Please enter the username for the user to be enabled"
        if (-not (checkUser $name)) {
            Write-Host "$name does not exist!" | Out-String
        }

        enableAUser $name
        Write-Host "User: $name Enabled." | Out-String
    }


    # Disable a user
    elseif($choice -eq 6){
        $name = Read-Host -Prompt "Please enter the username for the user to be disabled"

        if (-not (checkUser $name)) 
        {
            Write-Host "$name does not exist!" | Out-String
        }

       else{

        disableAUser $name

        Write-Host "User: $name Disabled." | Out-String
        }
    }


    elseif($choice -eq 7){
        $name = Read-Host -Prompt "Please enter the username for the user logs"
        if (-not (checkUser $name)) 
        {
            Write-Host "$name does not exist!" | Out-String
        }

        
        $userLogins = getLogInAndOffs | Read-Host -Prompt "enter # of days to search"

        Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)
    }


    elseif($choice -eq 8){
        $name = Read-Host -Prompt "Please enter the username for the user's failed login logs"
        if (-not (checkUser $name)) 
        {
            Write-Host "$name does not exist!" | Out-String
        }

        $userLogins = getFailedLogins | Read-Host -Prompt "enter # of days to search"

        Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)
    }

    else { Write-Host "Invalid choice: $choice" | Out-String }
}
