Param(
   [string]$collectionurl = "https://dev.azure.com/aaronw521",
   [string]$project = "BuildAndRelease",
   #definitionID
   [string]$defintionID="167",
   [string]$user = "aaron_wjp@hotmail.com",
   [string]$token = "2lphcfok5b7l5uj4rreinb3q6vas6lyplmo3bdjrerssqgikiamq"
)
# Base64-encodes the Personal Access Token (PAT) appropriately
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token)))

#Get resonse of the build definition
$updatedDefinitionURL= "$collectionurl/$project/_apis/build/definitions/$($defintionID)?api-version=5.0-preview.6"	
$updatedDefinition = Invoke-RestMethod -Uri $updatedDefinitionURL -Method get -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}

#Get all build definitions
$definitionURLs= "$collectionurl/$project/_apis/build/definitions?api-version=5.0-preview.6"

$definitions = Invoke-RestMethod -Uri $definitionURLs -Method get -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}

#use UpdatedDefinition.queue to other build definitions queue property
forEach($defintion in $definitions.value)
{
  # get one build pipeline according to ID
  $ID=$defintion.id
  $DefinitionURL = "$collectionurl/$project/_apis/build/definitions/$($ID)?api-version=5.0-preview.6"

  $getDefinition = Invoke-RestMethod -Uri $DefinitionURL -Method get -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
  #update the whole Queue
  Write-Host $updatedDefinition.queue.id
  $getfinition.queue=$updatedDefinition.queue
  Write-Host $DefinitionURL
  $json = @($getfinition) | ConvertTo-Json -Depth 99
   
  #Update build definition
  $updatedef = Invoke-RestMethod  -Uri $DefinitionURL  -Method Put -Body $json -ContentType "application/json" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
}