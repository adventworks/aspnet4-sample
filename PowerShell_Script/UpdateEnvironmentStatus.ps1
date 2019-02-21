$userId = "aaron_wjp@hotmail.com" 
$PAT = "7pjaoxm43artl5db7mtmxldkc4nx44ib53kjvp3mfkjpx66rer5a"
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $userId, $PAT))) 
$releaseId = 402 
#https://account.vsrm.visualstudio.com/Git2/_apis/Release/releases/{releaseID}

$JsonBody=ConvertTo-Json(@{
"status"="inProgress"
})
$getReleaseUri = "https://aaronw521.vsrm.visualstudio.com/ThreePaladins/_apis/release/releases/402/environments/1130?api-version=4.0-preview.4"
$aaa=Invoke-RestMethod -Uri $getReleaseUri  -Method Patch -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType "application/json" -Body $JsonBody
