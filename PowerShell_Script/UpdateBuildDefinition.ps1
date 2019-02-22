Param(
   [string]$collectionurl = "https://dev.azure.com/aaronw521/",
   [string]$project = "BuildAndRelease",
   [string]$user = "aaron_wjp@hotmail.com",
   [string]$token = "2lphcfok5b7l5uj4rreinb3q6vas6lyplmo3bdjrerssqgikiamq"
)

# Base64-encodes the Personal Access Token (PAT) appropriately
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token)))


# List all build pipeline pipelines in one project
$BuildPipelines = "$collectionurl/$project/_apis/build/definitions?api-version=5.0-preview.6"
$definitions = Invoke-RestMethod -Uri $BuildPipelines -Method get -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}

#Update pipelines agent

# Agent queue ID
$queueID="256"
forEach($defintion in $definitions.value)
{
  # get one build pipeline according to ID
  $ID=$defintion.id
  $defurl = "$collectionurl/$project/_apis/build/definitions/$($ID)?api-version=5.0-preview.6"
  
  $updatedefinition = Invoke-RestMethod -Uri $defurl -Method get -UseDefaultCredential -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
  #update Queue ID
  $updatedefinition.queue.id = $queueID

  $json = @($updatedefinition) | ConvertTo-Json -Depth 99
   
  #Update build definition
  $updatedef = Invoke-RestMethod  -Uri $defurl  -Method Put -Body $json -ContentType "application/json" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
}



#$definition.queue.pool.id = "2" 



