Clear
$PingList = Gc "C:\list.txt"
ForEach($MachineName In $PingList)
{$PingStatus = Gwmi Win32_PingStatus -Filter "Address = '$MachineName'" |
Select-Object StatusCode
If ($PingStatus.StatusCode -eq 0)
{Write-Host $MachineName -Fore "Green"}
Else
{Write-Host $MachineName -Fore "Red"}}