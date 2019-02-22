Param(
   #[string]$collectionUrl = "https://aaronsupport.vsrm.visualstudio.com",
   #[string]$project = "BuildRelease",
   [string]$user = "aaron_wjp@hotmail.com",
   [string]$token = "hsindoister65xkjodedtfhmlw4nk5essqn76x7pdk6h3prtgdva"
) 
# Base64-encodes the Personal Access Token (PAT) appropriately
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token))) 

$uri= "https://dev.azure.com/aaronsupport/Code/_apis/wit/workitems?ids=6,8,9,10&api-version=5.0-preview.3"
$response=Invoke-RestMethod -Uri $uri -Method Get -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType "application/json"
Write-Host $response.count

#Create Excel file by creating powershell objects. Following Line create object using excel.
$Excel = New-Object -ComObject excel.application
$excel.visible = $False
$workbook = $excel.Workbooks.Add()
#Then add worksheet to my workbook and rename it as “Data Set”. You can replace any name with it.
$diskSpacewksht= $workbook.Worksheets.Item(1)
$diskSpacewksht.Name = "Sheet Name"
#Now add column names and the Header for our excel. we use (row number,col number) format.
$diskSpacewksht.Cells.Item(1,8) = 'Header - Data Set Excel'
$diskSpacewksht.Cells.Item(2,1) = 'AreaPath'
$diskSpacewksht.Cells.Item(2,2) = 'ReproSteps'
$diskSpacewksht.Cells.Item(2,3) = 'Description'

#Please try to use some styles for our excel, to get some attractive look. in this case change the font family, font size, font color and etc.
$diskSpacewksht.Cells.Item(1,8).Font.Size = 18
$diskSpacewksht.Cells.Item(1,8).Font.Bold=$True
$diskSpacewksht.Cells.Item(1,8).Font.Name = "Cambria"
$diskSpacewksht.Cells.Item(1,8).Font.ThemeFont = 1
$diskSpacewksht.Cells.Item(1,8).Font.ThemeColor = 4
$diskSpacewksht.Cells.Item(1,8).Font.ColorIndex = 55
$diskSpacewksht.Cells.Item(1,8).Font.Color = 8210719


foreach($workItem in $response.value)
{
  $fields=$workItem.fields
  $ID=$workItem.id
  $Title=$fields."System.Title"
  Write-Host "ID: " $ID
  Write-Host "Title: " $Title
  
 
  
  #List work item fields 
  $AreaPath=$fields."System.AreaPath"
  $Description=$fields."System.Description"
  $ReproSteps=$fields."Microsoft.VSTS.TCM.ReproSteps"
  #Get more fields values ......
  #........
  Write-Host "AreaPath: " $AreaPath
  Write-Host "Description: " $Description
  Write-Host "ReproSteps: " $ReproSteps
  Write-Host "************************************************************"  
  
  # Add a row and  work item field value into Excel file 
  $diskSpacewksht.Cells.Item($ID+2,1) = $AreaPath 
  $diskSpacewksht.Cells.Item($ID+2,2) = $ReproSteps 
  $diskSpacewksht.Cells.Item($ID+2,3) = $Description 
  $excel.DisplayAlerts = 'False'
  
}
# Save Data
$path="C:\Users\aaronw\Desktop\Excel\WorkItems.xlsx"
Remove-Item –path $path –recurse
$workbook.SaveAs($path) 
$workbook.Close
$excel.DisplayAlerts = 'False'
$excel.Quit()



