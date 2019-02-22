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
        [int]$latestRequest=[int]$environment.deploySteps.count-1
        Write-Host "Requestor is : " $environment.deploySteps[$latestRequest].requestedBy.uniqueName
        #Download
        foreach($pha in $environment.deploySteps[$latestRequest].releaseDeployPhases)
        {
          foreach($Job in $pha.deploymentJobs)
          {
            foreach($Task in $Job.tasks)
            {
              $TasklogURL=$Task.logUrl
              $releaseName=$release.name
              $enironmentName=$environment.name
              $TaskName=$Task.name
              #create a folder for a Prod deployment
              New-Item -Path D:\temp\$project\$releaseName\$enironmentName -ItemType directory -force
              #Task file
              $filename = "D:\temp\$project\$releaseName\$enironmentName\$TaskName.txt"
             
              $reponseBody=Invoke-RestMethod -Uri $uri -Method Get -ContentType "application/json" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -OutFile $filename
              
            }
          }
        }
        
      }
    }
  }
}
