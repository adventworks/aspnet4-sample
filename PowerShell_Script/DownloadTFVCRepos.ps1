Param
(
  [string]$user = "aaron_wjp@hotmail.com",
  [string]$token = "hsindoister65xkjodedtfhmlw4nk5essqn76x7pdk6h3prtgdva"
)
# Project array List all project names
$Projects=@("BuildRelease","Code","WorkItems")
Foreach($project in $Projects)
{
  $downloaduri = "https://dev.azure.com/aaronsupport/$project/_apis/tfvc/items?path=$/$project&api-version=5.0-preview.1"
  $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token)))
  $response = Invoke-RestMethod -Uri $downloaduri -Method Get -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo);Accept="application/zip"} -OutFile "D:\\a\\$project.zip"
}
