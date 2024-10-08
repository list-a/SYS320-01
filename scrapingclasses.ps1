function gatherClasses(){
    $page = Invoke-WebRequest -TimeoutSec 10 "http://10.0.17.22/Courses-1.html"

    $trs = $page.ParsedHTML.body.getElementsByTagName("tr")

    $FullTable = @()
    for ($i = 1; $i -lt $trs.length; $i++){
    $tds = $trs[$i].getElementsByTagName("td")

    $Times = $tds[5].innerText.Split("-")
    $FullTable +=  [pscustomobject]@{"Class Code" = $tds[0].outerText;
"Title" = $tds[1].outerText;
"Days" = $tds[4].outerText;
"Time Start" = $Times[0];
"Time End" = $Times[1];
"Instructor" = $tds[6].outerText;
"Location" = $tds[9].outerText;
   }
    }
daysTranslator $FullTable
return $FullTable
}
gatherClasses
    function daysTranslator($FullTable){
    for ($i = 0; $i -lt $FullTable.length; $i++){
        $Days = @()

        if($FullTable[$i].Days -ilike "M"){ $Days += "Monday" }
        if($FullTable[$i].Days -ilike "T"){ $Days += "Tuesday" }
        ElseIf($FullTable[$i].Days -ilike "T"){ $Days += "Tuesday" }
        if($FullTable[$i].Days -ilike "W"){ $Days += "Wednesday" }
        if($FullTable[$i].Days -ilike "Th"){ $Days += "Thursday" }
        if($FullTable[$i].Days -ilike "F"){ $Days += "Friday" }
        $FullTable[$i].Days = $Days
    }

    return $FullTable
}

$FullTable | Select "Class Code", Instructor, Days, "Time Start", "Time End" | where {$_."Instructor" -ilike "Fur Paligu"}
#$FullTable | Where { ($_.Location -ilike "JOYCe 310") -and ($_.days -ilike "Monday")} | Sort-Object "Time Start" | Select "Time Start", "Time End", "Class Code"
$ITSInstructors = $FullTable | Where { 
    ($_."Class Code" -ilike "SYS*") -or `
($_."Class Code" -ilike "NET*") -or `
($_."Class Code" -ilike "SEC*") -or `
($_."Class Code" -ilike "FOR*") -or `
($_."Class Code" -ilike "CSI*") -or `
($_."Class Code" -ilike "DAT*") 
 }| Select "Instructor" | Sort-Object "Instructor"
    # $ITSInstructors                                   
#$FullTable | Where { $_.Instructor -in $ITSInstructors.Instructor } | Group "Instructor" | Select-Object Count, Name | Sort-Object Count -Descending
