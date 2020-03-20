$host = $args[0]
$scriptpath = $args[1]

Invoke-command -ComputerName $host -FilePath $scriptpath

#$s = New-PSSession -ComputerName $host
#
#Invoke-Command -Session $s {$h = Get-HotFix}