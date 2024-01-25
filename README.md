# Abusing Laps Toolkit

## Introduction
If the ```ms-DS-Machine-Account-Quota``` attribute value is default and there is no delegation about domain join permissions to add computer to Active Directory , a domain user can add computer account to domain using the ```ms-ds-machine-account-quota``` attribute .  The domain user reads password (```ms-mcs-admpwd```) of local administrator user for the added host after LAPS is installed and uses the password for persistence. When setting up LAPS, only certain users are assigned password reading permission. However, the user obtains `All extended rights` over the added computer so that reads LAPS password. The user can bypass GPO restrictions obtaining password of local admin user, even after the user no longer has local Administrator privileges on a machine. For example, user can edit registry settings or add own account to local administrators group after GPO which removes undefined users from local administrators group.

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
## Vulnerable Situations
1. A domain user can escalate privilege over computer that was added by own when a laps gpo is applied to computer. (documented in this blog):<br>
   a. The machine account password change is initiated by the computer every 30 days by default.<br>
   b. The restricted groups gpo can remove the user from local administrators group.<br>
   The user still can escalate privilege to local admin reading `ms-mcs-admpwd` after above two situations.<br>
   
2. The Laps gpo is applied to `PC` organizational unit and `lapsAdmin` group delegated for LAPS management.<br>
   The user has adding computer right to `PC` organizational unit and is not member of `lapsAdmin` group.<br>
   The user can read `ms-mcs-admpwd` attribute of computer that was added by own.<br>
   
## Mitigation
Microsoft LAPS installation document is updated. So you can make configuration according to Microsoft LAPS_OperationsGuide.docx and LAPS_TechnicalSpecification documents. https://www.microsoft.com/en-us/download/confirmation.aspx?id=46899
If Laps Administrator Password Solution is used, set ms-ds-machine-account-quota as "0" or delegation must be applied a user group for adding computer to domain. Otherwise user can add computer to domain and read local admin user password, define password complexity via LAPS misconfiguration. 

![alt text](https://github.com/passtheticket/Abusing_Laps_Toolkit/blob/main/laps_operations_guide.PNG)

## Details
https://docs.unsafe-inline.com/unsafe/abusing-laps
