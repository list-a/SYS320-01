function grub {
$log = Get-Content C:\xampp\apache\logs\access.log
$object = @()

for($i = 0; $i -lt $log.Count; $i++){
$info = $log[$i].Split(" ")

$object += [pscustomobject]@{
"IP" = $info[0]
"Time" = $info[3].Trim("[")
"Method" =$info[5].Trim(' " ')
"Page" =$info[6]
"Protocol" =$info[7]
"Response" =$info[8]
"Referrer" =$info[10]
"Client" =$info[11..($info.count -1 )];
}
}
return $log | Where-Object {$_. IP -ilike "10,*"}
}

(Join-Path $PSScriptRoot Untitled7.ps1)
$cout = grub
$cout | Format-Table -AutoSize -Wrap
