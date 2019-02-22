Param(
   [string]$collectionurl = "https://dev.azure.com/FHLB-Internal-dryrun/",
   [string]$project = "AffordableHousingProgram",
   [string]$user = "uajvi@fhlb.com",

   [string]$token = "vososn6tcv3qcrpvzz34do3qbxzhocenxn2z7kcarmj6ijfhcbia"
)

# Base64-encodes the Personal Access Token (PAT) appropriately
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token)))
#Get resonse of the build definition
$defurl = "$collectionurl/$project/_apis/build/definitions/645?api-version=3.2"			
$definition = Invoke-RestMethod -Uri $defurl -Method get -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}

Write-Host $definition.queue
# set agent queue
$queue="{
            '_links': {
                'self': {
                    'href': 'https://dev.azure.com/FHLB-Internal-dryrun/_apis/build/Queues/182'
                }
            },
            'id': 182,
            'name': 'VSTS',
            'url': 'https://dev.azure.com/FHLB-Internal-dryrun/_apis/build/Queues/182',
            'pool': {
                'id': 7,
                'name': 'VSTS'
            }
        }"
$definition.queue=$queue


$json = @($definition) | ConvertTo-Json -Depth 99

#Update build definition
$updatedef = Invoke-RestMethod  -Uri $defurl  -Method Put -Body $json -ContentType "application/json" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}

write-host $updatedef.queue.id