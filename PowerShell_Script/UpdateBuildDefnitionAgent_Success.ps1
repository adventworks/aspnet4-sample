Param(
  [string]$collectionurl = "https://dev.azure.com/FHLB-Internal-2-dryrun",
   [string]$project = "AffordableHousingProgram",
   #definitionID
   [string]$defintionID="228",
   [string]$user = "uajvi@fhlb.com",
   [string]$token = "dnzytr4nks3jrhemyh5dph5d347t4jj4h3yhxte5ftx4cvzxkuta"
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
  Write-Host "Definiton ID is:**************************************************************************************************** "
  Write-Host "Definiton ID is:**************************************************************************************************** "
  Write-Host $getDefinition.id
  if(!$getDefinition.queue)
  {
     Write-Host "defintion queue is null"
     #$getDefinition | add-member -Name "queue" -value $updatedDefinition.queue -MemberType NoteProperty 
     $getDefinition | Add-Member -NotePropertyName queue -NotePropertyValue $updatedDefinition.queue 
  }
  else
  {
      forEach($pha in $getDefinition.process.phases )
      {
         if($pha.Target.queue)
         { 
           Write-Host "*******************updated" 
           $getDefinition.process.phases.target.queue=$updatedDefinition.queue
         }
      }
      #update defintiion queue 
      $getDefinition.queue=$updatedDefinition.queue
  }

  $json = @($getDefinition) | ConvertTo-Json -Depth 99
  
  #Update build definition
  Write-Host $DefinitionURL
  $updatedef = Invoke-RestMethod  -Uri $DefinitionURL  -Method Put -Body $json -ContentType "application/json" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
  Write-Host  "******************updatd after"
  Write-Host  $getDefinition.queue
}