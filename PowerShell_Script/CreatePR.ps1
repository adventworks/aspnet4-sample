[uri] $PRUrl="https://aaronw521.visualstudio.com/CaseTest/_apis/git/repositories/f14b94b7-cfe7-436d-b0f2-51e605169289/pullRequests?api-version=4.1"
    # Base64-encodes the Personal Access Token (PAT) appropriately
    # This is required to pass PAT through HTTP header in Invoke-RestMethod bellow
    $User = "aaron_wjp@hotmail.com" # Not needed when using PAT, can be set to anything
    $PAT="brnt7i6mkrsorc7alh5jt7o6fe7alaod5eqqiorjcm2mb5ndc5da"
    $Base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $User,$PAT)))     

    # Prepend refs/heads/ to branches so shortened version can be used in title
    $Ref = "refs/heads/"
    $SourceBranch = "refs/pull/source"
    $TargetBranch = "refs/heads/master"
    $JSONBody= Convert-json{

            "targetRefName":"$SourceBranch",
            "targetRefName":"$TargetBranch",
            "title": "Merge $sourceRefName to $targetRefName",
            "description":"PR Created automajically via REST API "
        }
    $Response = Invoke-RestMethod -Uri $PRUri `
                                  -Method Post `
                                  -ContentType "application/json" `
                                  -Headers @{Authorization=("Basic {0}" -f $Base64AuthInfo)} `
                                  -Body $JSONBody  

    # Get new PR info from response
    $script:NewPRID = $Response.pullRequestId
    $script:NewPRURL = $Response.url
}

Try
{
    "Creating PR in $Repository repository: Source branch $SourceRefName Target Branch: $TargetRefName"
    CreatePullRequest
    "Created PR $NewPRID`: $NewPRURL"
}
Catch
{
    $result = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($result)
    $reader.BaseStream.Position = 0
    $reader.DiscardBufferedData()
    $responseBody = $reader.ReadToEnd();
    $responseBody
    Exit 1 # Fail build if errors
}