
Param(
   [string]$user = "suuajvi@fhlb.com",
   [string]$token = "7wd7nkb6vz3sj6bwr26gbrqdq5e7ezm74j2x27edd6tm4bog75kq"
) 
# Base64-encodes the Personal Access Token (PAT) appropriately
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token))) 

$uri= "https://dev.azure.com/FHLBCollection-1/Advances/_apis/wit/workitems?ids=1,2,3,4,5&api-version=5.0-preview.3"
# get specified work items
$response=Invoke-RestMethod -Uri $uri -Method Get -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType "application/json"

#Create Excel file by creating powershell objects. Following Line create object using excel.

$excel = New-Object -ComObject excel.application
$excel.visible = $False
$workbook = $excel.Workbooks.Add()
#Then add worksheet to my workbook and rename it as “Work Items”. You can replace any name with it.
$diskSpacewksht= $workbook.Worksheets.Item(1)
$diskSpacewksht.Name = "Work Items"
#Now add column names and the Header for our excel. we use (row number,col number) format.
$diskSpacewksht.Cells.Item(1,8) = 'Header - Data Set Excel'
$diskSpacewksht.Cells.Item(2,1) = 'AreaPath'
$diskSpacewksht.Cells.Item(2,2) = 'IterationPath'
$diskSpacewksht.Cells.Item(2,3) = 'WorkItemType'

#You can try to use some styles for our excel, to get some attractive look. in this case change the font family, font size, font color and etc.
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
  $IterationPath=$fields."System.IterationPath"
  $WorkItemType=$fields."System.WorkItemType"
  #Get more fields values ......
  #........
  Write-Host "AreaPath: " $AreaPath
  Write-Host "IterationPath: " $Description
  Write-Host "WorkItemType: " $ReproSteps
  Write-Host "************************************************************"  
  
  $col=4
  $col1=4
  # Add a row and  work item field value into Excel file 
  $diskSpacewksht.Cells.Item($ID+2,1) = $AreaPath 
  $diskSpacewksht.Cells.Item($ID+2,2) = $IterationPath 
  $diskSpacewksht.Cells.Item($ID+2,3) = $WorkItemType 
  $excel.DisplayAlerts = 'False'
  
}
# Save Data
$path="D:\WorkItems.xlsx"
Remove-Item –path $path –recurse
$workbook.SaveAs($path) 
$workbook.Close()

$excel.DisplayAlerts = 'False'
$excel.Quit() 
