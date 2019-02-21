Param(
   [string]$vstsAccount = "weiweicai",
   [string]$buildNumber = "<BUILD-NUMBER>",
   [string]$keepForever = "true",
   [string]$user = "Weiwei Cai",
   [string]$token = "yvnqs5syvil7zp3lpvffae6vwfz7lrvvctwnk7ly7ahaykejabcq"
)
 
# Base64-encodes the Personal Access Token (PAT) appropriately
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token)))
 
# Construct the REST URL to obtain Build ID
$uri = "https://$($vstsAccount).visualstudio.com/DefaultCollection/_apis/wit/workitems/524?" + "`$expand" + "=relations&api-version=1.0"
Write-Host $uri
# Invoke the REST call and capture the results
$result = Invoke-RestMethod -Uri $uri -Method Get -ContentType "application/json" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}

foreach($link in $result.relations)
{
     #Get the linked Changeset url and you could deal with them here
}
 

