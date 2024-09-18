PowerShell First File

function func($days){

#Get-EventLog system -source Microsoft-Windows-Winlogon
$loginouts = Get-EventLog system -source Microsoft-Windows-Winlogon -After (Get-Date).AddDays(-$days)

$loginoutsTable = @()

for($i=0; $i -lt $loginouts.Count; $i++){
$event = ""
if($loginouts[$i].InstanceId -eq 7001) {$event="Logon"}
if($loginouts[$i].InstanceId -eq 7002) {$event="Logoff"}

$user = $loginouts[$i].ReplacementStrings[1]

$loginoutsTable += [pscustomobject]@{"Time" = $loginouts[$i].TimeGenerated;`
"Id" = $loginouts[$i].InstanceId;`
"Event" = $event;`
"User" = $user;

    }
}
$loginoutsTable

for( $i = 0; $i -lt  $loginouts.Count; $i++){
$SID = New-Object System.Security.Principal.SecurityIdentifier($loginoutsTable[$i].User)

$loginoutsTable[$i].User = $SID.Translate([System.Security.Principal.NTAccount])
}
$loginoutsTable
}
func(14)

function getShutdownStartTime($days){

$loginouts = Get-EventLog system -source Microsoft-Windows-Winlogon -After (Get-Date).AddDays(-$days)

$table = @()
for($i=0; $i -lt $loginouts.Count; $i++){
$event = ""
if($loginouts[$i].EventId -eq 6005) {$event="Startup"}
if($loginouts[$i].EventId -eq 6006) {$event="Shutdown"}

if ($event -ne ""){
$table += [pscustomobject]@{"Time" = $loginouts[$i].TimeGenerated;`
"Id" = $loginouts[$i].EventId;`
"Event" = $event;`
"User" = "System";`
}
}
}
return $table
}

getShutdownStartTime(14)
clear
$loginoutsTable = func(14)
$loginoutsTable

$startTable = getShutdownStartTime(14)
$startTable
