"
______________________________
|                            |
| @@@@@@@@@@@@@@@@@@@@@@@@@@ |
| @                        @ |
| @           /\           @ | 
| @         {    }         @ |				PowerArmor v0.1
| @          |  |          @ |				
| @          |  |          @ |				Ethan Michalak 
| @   ^ -----|  |----- ^   @ |
| @ <                    > @ |				Remote Powershell Framework
| @   \/-----|  |-----\/   @ |
| @          |  |          @ |
| @          |  |          @ |
| @          |  |          @ |
| @          |  |          @ |
| @          |  |          @ |
| @         {    }         @ |
| @           \/           @ |
 \ @                      @ /
  \ @                    @ /
   \ @                  @ /      
    \ @                @ /     
     \ @              @ /
      \ @            @ /
       \ @@@@@@@@@@@@ /
        --------------
"

function Invoke-PA 
{
<#
.SYNOPSIS

This script aims at lowering secure time of incident response teams by allowing mass deployment
of powershell commands or other prewritten functions. 
Uses WinRM to open up sessions on specified IPs or hosts.

.DESCRIPTION

.PARAMETER ComputerName

Computers that are targeted.

.PARAMETER Inventory

Switch: Collects inventory in text files

.PARAMETER Custom

Custom command override.

.EXAMPLE

Grab inventory off of supplied IPs
Invoke-PA -Inventory -ComputerName @("172.168.2.3", "172.168.2.4")

#>

[CmdletBinding(DefaultParameterSetName="")]
Param(
	[Parameter(Position = 0)]
	[String[]]
	$ComputerName,

	[Parameter(Position = 1)]
	[Switch]
	$Inventory,

	
)

}

