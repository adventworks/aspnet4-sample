$accountName="aaronsupport"
$projectName="BuildRelease"
$user = "aaron_wjp@hotmail.com"
$token = "qjovjbahyh6flwus6pjp6pfrzpwk3bjle6iwr6344hikm7k2natq"
# Base64-encodes the Personal Access Token (PAT) appropriately
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token))) 

$definitionNameToRecover = "Test03"
# Find the Id of release definition that got deleted
$deletedReleaseDefinitionsUri = "https://$accountName.vsrm.visualstudio.com/$projectName/_apis/Release/definitions?api-version=4.0-preview.3&isDeleted=true&searchText=$definitionNameToRecover"
$deletedDefinitions = Invoke-RestMethod -Uri $deletedReleaseDefinitionsUri -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType “application/json" -Method Get
$deletedDefinitionJSON = $deletedDefinitions | ConvertTo-Json -Depth 100
write-host "Found the deleted definitions : $deletedDefinitions"
$deletedReleaseDefinitionId = $deletedDefinitions.Value[0].id
write-host "Found the deleted id : $deletedReleaseDefinitionId "

# Recover the deleted release definition
$undeleteReason = '{ "Comment" : "Deleted by mistake" }'
$undeleteReleaseDefinitionUri = "https://$accountName.vsrm.visualstudio.com/$projectName/_apis/Release/definitions/$deletedReleaseDefinitionId`?api-version=4.0-preview.3"
$undeletedDefinition = Invoke-RestMethod -Uri $undeleteReleaseDefinitionUri -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType “application/json" -Method Patch -Body $undeleteReason
$name = $undeletedDefinition.name
write-host "$name recovered successfully"