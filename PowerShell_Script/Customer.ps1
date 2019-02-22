Param(
   [string]$collectionurl = "https://dev.azure.com/FHLB-Internal-dryrun/",
   [string]$project = "AffordableHousingProgram",
   # Agent queue ID
   [string]$queueID = "182", 
   [string] $poolID="7",
   [string]$user = "uajvi@fhlb.com",
   [string]$token = "vososn6tcv3qcrpvzz34do3qbxzhocenxn2z7kcarmj6ijfhcbia"
)
 
# Base64-encodes the Personal Access Token (PAT) appropriately
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token)))
 
 
# List all build pipeline pipelines in one project
$BuildPipelines = "$collectionurl/$project/_apis/build/definitions?api-version=5.0-preview.6"
$definitions = Invoke-RestMethod -Uri $BuildPipelines -Method get -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
 
#Update pipelines agent
 Write-Host $definitions

forEach($defintion in $definitions.value)
{
  # get one build pipeline according to ID
  $ID=$defintion.id
  Write-Host $ID
  
  $defurl = "$collectionurl/$project/_apis/build/definitions/$($ID)?api-version=5.0-preview.6"
   Write-Host $defurl
  $getfinition = Invoke-RestMethod -Uri $defurl -Method get -UseDefaultCredential -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
  #update Queue ID

  Write-Host $defintion.queue. ID
  Write-Host "***********"
  $getfinition.queue.id = $queueID
  $getfinition.que.id=$poolID
  Write-Host $defintion.queue. ID
  $json = @($getfinition) | ConvertTo-Json -Depth 99
   
  #Update build definition
  $updatedef = Invoke-RestMethod  -Uri $defurl  -Method Put -Body $json -ContentType "application/json" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
}
