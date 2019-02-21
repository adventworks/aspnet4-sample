Param(
   [string]$collectionUrl = "https://aaronsupport.vsrm.visualstudio.com",
   [string]$user = "aaron_wjp@hotmail.com",
   [string]$project="BuildRelease",
   [string]$token = "hsindoister65xkjodedtfhmlw4nk5essqn76x7pdk6h3prtgdva"
) 
# Base64-encodes the Personal Access Token (PAT) appropriately
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token))) 

$DefinitionURL = "$collectionUrl/$project/_apis/Release/definitions/2?api-version=5.0-preview.3"
$ReleaseDefinition=Invoke-RestMethod -Uri $DefinitionURL -Method Get -ContentType  "application/json" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
#Write-Host $ReleaseDefinition
#
#create an object which is related with the information of Retain indefinitely current release task
$RetainIndifinitely=@{environment={}
                            taskId="d96e8c90-0fdd-11e8-a8b1-79ecfcf1be7c"
                            version="2.*"
                            name="Retain indefinitely current release"
                            refName=""
                            enabled="true"
                            alwaysRun="false"
                            continueOnError="true"
                            timeoutInMinutes="0"
                            definitionType="task"
                            overrideInputs={}
                            condition="succeeded()"
                            inputs='{"lock": "true"}'
                            }

#get tasks array of the first environment of release definition
$workflowTasks=$ReleaseDefinition.environments[0].deployPhases[0].workflowTasks
#Add Retain indefinitely current release task into task array
$workflowTasks+=$RetainIndifinitely
#update environment
$ReleaseDefinition.environments[0].deployPhases[0].workflowTasks=$workflowTasks
# Convert to json
$json = @($ReleaseDefinition) | ConvertTo-Json -Depth 99
#update release definition
Write-Host $json
$updatedef = Invoke-RestMethod  -Uri $DefinitionURL  -Method Put -Body $json -ContentType "application/json" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}

