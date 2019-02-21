$collectionUrl = "https://aaronsupport.vsrm.visualstudio.com"
$user = "aaron_wjp@hotmail.com"
$token = "hsindoister65xkjodedtfhmlw4nk5essqn76x7pdk6h3prtgdva"

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token))) 

#List all projects
$Projects=@("BuildRelease")
Foreach($project in $Projects)
{
  # List all releases in one project
  $ReleasesURL = "$collectionurl/$project/_apis/release/releases?api-version=5.0-preview.6"
  Write-Host "all Release URLs:" $ReleasesURL
  $Releases = Invoke-RestMethod -Uri $ReleasesURL -Method get -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
  Foreach($Rel in $Releases.value)
  {
    $ID= $Rel.id
    $ReleaseURL="$collectionUrl/$project/_apis/release/releases/$($ID)?api-version=5.0-preview.8"
    #Get one release 
    $release= Invoke-RestMethod -Uri $ReleaseURL -Method Get -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
   
    # for loop environments of One release
    foreach($environment in $release.environments)
    {
      
      # Downlaod the logs of release including Prod Deployment
      If($environment.name -eq "Prod")
      {  
        Write-Host "*****************************************************"
        #Deployment request
        Write-Host $environment.deploySteps.count
        [int]$latestRequest=[int]$environment.deploySteps.count-1
        Write-Host "latestRequest value "$latestRequest
        Write-Host "Requestor is : " $environment.deploySteps[$latestRequest].requestedBy.uniqueName
        #Download
        $filename = "D:\temp\ReleaseLogs_$ID.zip"
        $ReleaseURL="$collectionUrl/$project/_apis/release/releases/$($IDlatestRequest)?api-version=5.0-preview.8"
        $release= Invoke-RestMethod -Uri $ReleaseURL -Method Get -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
        $uri = "$collectionUrl/$project/_apis/Release/releases/$ID/logs"   
        Invoke-RestMethod -Uri $uri -Method Get -ContentType "application/zip" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -OutFile $filename
      }
    }
  }
}
