Param(
   [string]$collectionurl = "https://dev.azure.com/aaronw521/",
   [string]$project = "BuildAndRelease",
   [string]$definitionid = "174",
   [string]$user = "aaron_wjp@hotmail.com",
   [string]$token = "bnqymwtz7ifghcy6ymmifncpjp5me263fjerkile2gruezbsd3aq"
)

# Base64-encodes the Personal Access Token (PAT) appropriately
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token)))
#Get resonse of the build definition
$defurl = "$collectionurl/$project/_apis/build/definitions/$($definitionid)?api-version=3.2"			
$definition = Invoke-RestMethod -Uri $defurl -Method get -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}

# set agent queue
$definition.queue.id = "254"
$definition.queue.pool.id = "16"


$json = @($definition) | ConvertTo-Json -Depth 99

#Update build definition
$updatedef = Invoke-RestMethod  -Uri $defurl  -Method Put -Body $json -ContentType "application/json" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}

write-host $updatedef.queue.id
