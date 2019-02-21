$userId = "aaron_wjp@hotmail.com" 
$PAT = "7pjaoxm43artl5db7mtmxldkc4nx44ib53kjvp3mfkjpx66rer5a"
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $userId, $PAT))) 
$headers=@{Authorization=("Basic {0}" -f $base64AuthInfo)}
#$headers = @{ Authorization = "Bearer $env:SYSTEM_ACCESSTOKEN" }

$downloadUri = "https://aaronw521.visualstudio.com/65d44428-ee85-47c3-8bcf-2ec4bbc82a5a/_apis/git/repositories/ScrumProject/items?scopePath=/bin/Test.txt&download = true&format = 'octetStream'&versionDescriptor.versionOptions=none&escriptor.version = a502e00d303c12510c6fee5168a7d3aa6994cefe&versionDescriptor.versionType = 'commit'&api-version= 4.1"

 Write-Host $downloadUri

Invoke-RestMethod -Method Get -Uri $downloadUri -Headers $headers -OutFile 'D:\\Version.txt'