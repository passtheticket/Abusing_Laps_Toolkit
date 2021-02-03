function Get-LapsAdmPwd {
    <#
    .SYNOPSIS
        This script reads ms-Mcs-AdmPwd and ms-Mcs-AdmPwdExpirationTime attributes if user have all extended rights on computer account without
        local admin privileges.
    
    .PARAMETER LapsInstalled
        The parameter LapsInstalled is used to define the AdmPwd.PS module is installed.

    .PARAMETER OtherComputer
        The parameter OtherComputer is used to query for other computer.

    .EXAMPLE
        PS C:\> Get-LocalAdminPassword –LapsInstalled
	    PS C:\> Get-LocalAdminPassword –LapsInstalled -OtherComputer
    
    .NOTES
        Windows Powershell should be run as domain user rights. If GPO is applied which only specified users join local adminstrators group , this script could be executed without admin rights.  

        If running scripts is disabled on your system, execute following command firstly.
        Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser

    #>
        param (
    
            [switch]$LapsInstalled,
            [switch]$OtherComputer
        ) 
        begin {
            
            Write-Host "Obtaining ms-mcs-admpwd attribute value via MS-DS-Machine-Account-Quota" -ForegroundColor Green
        }
        process {
          
            $dPath = $env:USERPROFILE
            Write-Host "UserProfile: $dPath" -ForegroundColor Yellow
            $hName = $env:COMPUTERNAME
            Write-Host "Computername: $hName" -ForegroundColor Yellow
            Write-Host "[*] Did you install LAPS management powershell module? $LapsInstalled"
            if ($LapsInstalled) {
                Import-Module AdmPwd.PS
                Write-Host "[*] Would you like to query another computer account you added yourself? $otherComputer"
                if ($OtherComputer) {
                    $computer = Read-Host -Prompt "[*] Computer name "
                    Get-AdmPwdPassword -ComputerName $computer | format-list -Property ComputerName, ExpirationTimestamp, Password  
                        
                } else {
                    Get-AdmPwdPassword -ComputerName $hname | format-list -Property ComputerName, ExpirationTimestamp, Password 
                        
                }
            } else {
                Write-Host "[-] Cancelled!" -ForegroundColor Red
            }
            }

}
