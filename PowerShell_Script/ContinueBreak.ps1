$Phase01=@("1","2","3")
$Phase01=@("1","2","3")
Foreach($value in $Phase01)
{
   Foreach($value1 in $Phase01)
   {
    if($value1 -eq "1")
    {
      #Continue
      break
    }
    else
    {
       Write-Host "value1 >" $value1
    }
   }
   Write-Host "value1 >" $value
}