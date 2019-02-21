Param(
   [string]$collectionUrl = "https://aaronsupport.vsrm.visualstudio.com",
   [string]$project = "BuildRelease",
   [string]$user = "aaron_wjp@hotmail.com",
   [string]$token = "hsindoister65xkjodedtfhmlw4nk5essqn76x7pdk6h3prtgdva"
) 
# Base64-encodes the Personal Access Token (PAT) appropriately
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token))) 
# Project array List all project names
$Projects=@("BuildRelease","Code","WorkItems")
Foreach($project in $Projects)
{
  
  # Get all definitions
  $ListDefsURL="$collectionUrl/$project/_apis/Release/definitions"
  $definitions= Invoke-RestMethod -Uri $ListDefsURL -Method Get -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
  #loop all definitions
  Foreach($def in $definitions.value)
  {
    Write-Host "********************************"
    #Download Definition
    $DefID=$def.id
    $DefName=$def.name
    #$FileName = "D:\Definitions\Releases\$project\$DefName.json"
    $uri = "$collectionUrl/$project/_apis/Release/definitions/$DefID"
    Invoke-RestMethod -Uri $uri -Method Get -ContentType  "application/zip" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -OutFile $FileName
  }
  # archive a folder with project name as folder.zip
  #Compress-Archive -Path D:\Definitions\Releases\$project -DestinationPath D:\Definitions\Releases\$project.zip -Force
  # delete a folder with project name
  #Remove-Item –path D:\Definitions\Releases\$project –recurse
}