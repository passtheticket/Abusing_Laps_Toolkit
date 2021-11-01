# Abusing Laps Toolkit

## Introduction
If the ```ms-DS-Machine-Account-Quota``` attribute value is default, there is no delegation about domain join permissions to add computer to Active Directory , a domain user can add computer account to domain using the ```ms-ds-machine-account-quota``` attribute .  So that domain user reads password (```ms-mcs-admpwd```) of local administrator user and uses the password for persistence. The user can bypass GPO restrictions obtaining password of local admin user. For example, user can edit registry settings or add own account to local administrators group after GPO which removes undefined users from local administrators group.

1. Open non-domain joined Windows virtual machine.
2. Download LAPS.x64.msi and install it with powershell module extension (AdmPwd.PS)
3. Import AdmPwd.PS 
* ```powershell
  Import-Module AdmPwd.PS
  ```
4. Add computer to Active Directory with domain user creds:
* ```powershell
  Add-ComputerToDomainWithUserRights
  ```

5. Read local admin password and determine password policy:
   * If you are still a member of local administrators after updating GPO.  
   Read ms-mcs-admpwd attribute via PowerView.ps1:   
     ```powershell
     Get-LapsLocalAdminPassword -disableDefender
     ```

   * If you are not a member of local administrators after updating GPO.  
   Read ms-mcs-admpwd attribute via AdmPwd.PS:   
     ```powershell
     Get-LapsAdmPwd -LapsInstalled
     ```


## Mitigation
Microsoft LAPS installation document is updated. So don't configuration according to Microsoft LAPS_OperationsGuide.docx and LAPS_TechnicalSpecification documents. https://www.microsoft.com/en-us/download/confirmation.aspx?id=46899
If Laps Administrator Password Solution is used, set ms-ds-machine-account-quota as "0" or delegation must be applied a user group for adding computer to domain. Otherwise user can add computer to domain and read local admin user password, define password complexity via LAPS misconfiguration. 

## Details
https://docs.unsafe-inline.com/unsafe/abusing-laps
