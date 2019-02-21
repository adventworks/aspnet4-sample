$collectionUrl = "https://aaronsupport.vsrm.visualstudio.com"
$user = "aaron_wjp@hotmail.com"
$token = "hsindoister65xkjodedtfhmlw4nk5essqn76x7pdk6h3prtgdva"
# Base64-encodes the Personal Access Token (PAT) appropriately
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token))) 

#list all projects
$Projects=@("BuildRelease")
foreach($project in $Projects)
{
   $DefinitionsURL= "$collectionUrl/$project/_apis/Release/definitions?api-version=5.0-preview.3"
   Write-Host "List Release definition URL: " $DefinitionsURL
   $definitions = Invoke-RestMethod -Uri $DefinitionsURL -Method get -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
   Write-Host
   foreach($definition in $definitions.value)
   {
      $ID=$definition.id
      Write-Host "ID : "$ID
      $ReleaseDefURL = "$collectionUrl/$project/_apis/Release/definitions/$($ID)?api-version=5.0-preview.3"
      Write-Host "One Release definition URL: " $ReleaseDefURL
      $ReleaseDefinition=Invoke-RestMethod -Uri $ReleaseDefURL -Method Get -ContentType  "application/json" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}

      #create an object which is related with the information of Retain indefinitely current release task
      $RetainIndifinitely=@{environment="{}"
                            taskId="d96e8c90-0fdd-11e8-a8b1-79ecfcf1be7c"
                            version="2.*"
                            name="Retain indefinitely current release"
                            refName=""
                            enabled="true"
                            alwaysRun="false"
                            continueOnError="false"
                            timeoutInMinutes="0"
                            definitionType="task"
                            overrideInputs="{}"
                            condition="succeeded()"
                            inputs='{"lock": "true"}'
                            }
      
        #get tasks array of the first environment of release definition
        for($index=0; $index -lt $ReleaseDefinition.environments.count; $index ++)
        {

            $workflowTasks=$ReleaseDefinition.environments[$index].deployPhases[0].workflowTasks
            #Add Retain indefinitely current release task into task array
            $workflowTasks+=$RetainIndifinitely
            #create an array used to add all tasks' names
            $taskNames=@()
            for($i=0; $i -lt $ReleaseDefinition.environments[$index].deployPhases[0].workflowTasks.count; $i ++)
            {
              $name=$ReleaseDefinition.environments[$index].deployPhases[0].workflowTasks[$i].name
              #add task into $taskNames array
              $taskNames+=$name
            }
            # retrieve whether the $taskNames contains Retain indefinitely current release task name, if yes, skip the current loop and retrive the next environment
            if($taskNames.contains("Retain indefinitely current release"))
            {
               Write-Host "the first agent job of the " $ReleaseDefinition.environments[$index].name  "environment has a Retain indefinitely current release task"
               continue
            }
            else
            { 
              Write-Host "add a Retain indefinitely current release task into " $ReleaseDefinition.environments[$index].name
              $ReleaseDefinition.environments[$index].deployPhases[0].workflowTasks=$workflowTasks
            }
            
        }

        # Convert to json
        $json = @($ReleaseDefinition) | ConvertTo-Json -Depth 10
        #Write-Host "**********************************************************************************************"
        #update release definition
        $updatedef = Invoke-RestMethod  -Uri $ReleaseDefURL  -Method Put -Body $json -ContentType "application/json" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
   }
}

