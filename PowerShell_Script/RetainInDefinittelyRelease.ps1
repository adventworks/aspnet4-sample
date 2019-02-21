Param(
   [string]$collectionUrl = "https://vsrm.dev.azure.com/aaronsupport",
   [string]$user = "aaron_wjp@hotmail.com",
   [string]$token = "hsindoister65xkjodedtfhmlw4nk5essqn76x7pdk6h3prtgdva"
)

# Base64-encodes the Personal Access Token (PAT) appropriately
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token)))

# list more projects $Projects=@("BuildRelease","Project2")
$Projects=@("BuildRelease")
Foreach($project in $Projects)
{
  # List all releases in one project
  $ReleasesURL = "$collectionurl/$project/_apis/release/releases?api-version=5.0-preview.6"
  Write-Host "all Release URLs:" $ReleasesURL
  $Releases = Invoke-RestMethod -Uri $ReleasesURL -Method get -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}

  #update Releases
  Foreach($release in $Releases.value)
  {
    Write-Host "*****************************************************"
    $ID= $release.id
    Write-Host $release.Id
    Write-Host $release.Name
    # get one release 
    $ReleaseURL="$collectionUrl/$project/_apis/release/releases/$($ID)?api-version=5.0-preview.8"
    Write-Host $ReleaseURL
    $release= Invoke-RestMethod -Uri $ReleaseURL -Method Get -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
    #update release
    Write-Host "Update before> "$release.keepForever
    # update release keepForever property to set Retain Indifinitely.
    $release.keepForever="true"
    $release.status="Completed"
    $json = @($release) | ConvertTo-Json -Depth 99
    Write-Host $json
    $updateRelease = Invoke-RestMethod  -Uri $ReleaseURL  -Method Patch -Body $json -ContentType "application/json" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
    Write-Host "Update after> "$release.keepForever
  }
}


