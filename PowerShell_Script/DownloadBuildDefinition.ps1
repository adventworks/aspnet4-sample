Param(
   [string]$collectionUrl = "https://aaronsupport.visualstudio.com",
   #[string]$project = "BuildRelease",
   [string]$user = "aaron_wjp@hotmail.com",
   [string]$token = "hsindoister65xkjodedtfhmlw4nk5essqn76x7pdk6h3prtgdva"
) 
# Base64-encodes the Personal Access Token (PAT) appropriately
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token))) 
$Projects=@("BuildRelease","Code","WorkItems")
Foreach($project in $Projects)
{
  #Create a folder named with project name
  New-Item -Path D:\Definitions\Builds\$project -ItemType directory -force
  # Get all definitions
  $ListDefsURL="$collectionUrl/$project/_apis/build/definitions"
  $definitions= Invoke-RestMethod -Uri $ListDefsURL -Method Get -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
  #loop all definitions
  Foreach($def in $definitions.value)
  {
   Write-Host "********************************"
   #Download Definition
   $DefID=$def.id
   $DefName=$def.name
   
   $FileName = "D:\Definitions\Builds\$project\$DefName.json"
   $uri = "$collectionUrl/$project/_apis/build/definitions/$DefID"
   Invoke-RestMethod -Uri $uri -Method Get -ContentType  "application/zip" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -OutFile $FileName
  }
  # Archive project folder
  Compress-Archive -Path D:\Definitions\Builds\$project -DestinationPath D:\Definitions\builds\$project -Force
  # delete a folder with project name
  Remove-Item –path D:\Definitions\builds\$project –recurse
}

#$uri = "$collectionUrl/$project/_apis/build/definitions/$DefinitionID"
#https://aaronsupport.visualstudio.com/BuildRelease/_apis/build/definitions 
#Write-Host $uri
#Invoke-RestMethod -Uri $uri -Method Get -ContentType  "application/zip" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -OutFile $filename