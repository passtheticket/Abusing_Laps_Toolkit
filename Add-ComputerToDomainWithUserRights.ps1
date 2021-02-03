function Add-ComputerToDomainWithUserRights {
<#
.SYNOPSIS
    This script joins a computer to domain with domain user rights by using ms-DS-Machine-Account-Quota attribute.
    Also, adds domain user to local Administrators group.

.PARAMETER dcIp
    The parameter dcIp is used to define the IPv4 address of Domain Controller.

.PARAMETER dName
    The parameter dName is used to define the Domain Name.

.PARAMETER uName
    The parameter uName is used to define the value of Domain User samAccountName attribute. 
 
.PARAMETER restart
    The parameter restart is used to restart computer after adding process.

.EXAMPLE
    PS C:\> Add-ComputerToDomainWithUserRights -restart
    PS C:\> Add-ComuterToDomainWithUserRights

.NOTES
    Windows Powershell must be run as Administrator on computer that will be joined to domain.
    If running script is disabled on your system, execute following command firstly:
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
#>
    param (
        [string]$dcIp = $(Read-Host -Prompt '[*] Domain Controller IPv4 address '),
        [string]$dName = $(Read-Host -Prompt '[*] Domain Name '),
        [string]$uName = $(Read-Host -Prompt '[*] Domain UserName '),
        [switch]$restart
    ) 
    begin {
        Get-NetAdapter
        [int]$index = $(Read-Host -Prompt '[*] Set index of interface ')
    }
    process {
        Set-DnsClientServerAddress -InterfaceIndex $index -ServerAddresses $dcIp -ErrorAction Stop
        Write-Host "[*] Adding computer account to Active Directory." -ForegroundColor Yellow
        Add-Computer -DomainName $dName -Credential $dName\$uName -Verbose -ErrorAction Stop
        Add-LocalGroupMember -Group "Administrators" -Member "$dName\$uName"
        Write-Host "[+] $uName domain user is added to local administrators group." -ForegroundColor Green
        Write-Host "[*] Restarting is required to achieve adding process." -ForegroundColor Yellow
        if ($restart) {
            Restart-Computer
        } else {
            Write-Host "[-] Computer restarting is cancelled!" -ForegroundColor Red
        }

    } 
        
    }  
