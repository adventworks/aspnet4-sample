$userId = "aaron_wjp@hotmail.com" 
$PAT = "b5cahzfafo4j55wt5aysbfkipyi3xanremlb4ab73sy4w3e2qa7a"
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $userId, $PAT))) 
$releaseId = 368 
$arr="@Mytag","ta/gss"
foreach($tag in $arr)
{
$getReleaseUri = "https://aaronw521.vsrm.visualstudio.com/ThreePaladins/_apis/release/releases/368/tags/$($tag)?api-version=5.0-preview.1" 
$aaa=Invoke-RestMethod -Uri $getReleaseUri  -Method patch -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
}

#$getResponse = Invoke-RestMethod $getReleaseUri -Method get -Headers  @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }

#$getResponse.tags = @("ThisIsMyTestTag", "ThisIsAnotherTestTag") 
#$Test=ConvertTo-Json $getResponse.tags
#Write-Host $Test
#$json = $getResponse | ConvertTo-Json -Depth 100 $updateReleaseUri = "https://https://aaronw521.vsrm.visualstudio.com/ThreePaladins/_apis/release/releases/$($releaseId)?api-version=5.0-preview.7"

#Write-Host $getResponse.tags
#Write-Host $getReleaseUri
