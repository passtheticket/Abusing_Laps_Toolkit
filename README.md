# Abusing Laps Toolkit

## Introduction
If the ```ms-DS-Machine-Account-Quota``` attribute value is default, there is no delegation about domain join permissions to add computer to Active Directory , a domain user can add computer account to domain using the ```ms-ds-machine-account-quota``` attribute .  So that domain user reads password (```ms-mcs-admpwd```) of local administrator user and uses the password for persistence. For example, user can edit registry settings or add own account to local administrators group after GPO which removes undefined users from local administrators group.

1. Add computer account to Active Directory:
* ``PS C:\> Add-ComputerToDomainWithUserRights``

2. Read ms-mcs-admpwd attribute via PowerView.ps1 (if you are still a member of local administrators after updating GPO)
* ``Get-LapsLocalAdminPassword -disableDefender``

3. Read ms-mcs-admpwd attribute via AdmPwd.PS (if you are not a member of local administrators after updating GPO) (You must install AdmPwd.PS in the step 1)
* ``Get-LapsAdmPwd -LapsInstalled``

If the ms-DS-Machine-Account-Quota attribute value is default and there is no delegation about domain join permissions to add computer to Active Directory , a domain user can add computer account to domain using the ms-ds-machine-account-quota attribute .  So that domain user reads password of local administrator user and uses the password for persistence. For example, user can edit registry settings or add own account to local administrators group after GPO which removes undefined users from local administrators group. Also, this is information disclosure vulnerability, user can add computer and read LAPS password so that he can obtain information about complexity and length of other Administrator passwords. Because, LAPS carries out similar password property for all computer accounts that group policy is applied.


## Mitigation
Microsoft LAPS installation document don't handle this issue and they didn't update it. So don't configuration according to Microsoft LAPS_OperationsGuide.docx and LAPS_TechnicalSpecification documents only. https://www.microsoft.com/en-us/download/details.aspx?id=46899
If Laps Administrator Password Solution is used, set ms-ds-machine-account-quota as "0" or delegation must be applied a user group for adding computer to domain. Otherwise user can add computer to domain and read local admin user password, define password complexity via LAPS misconfiguration. 

## Details
https://docs.unsafe-inline.com/unsafe/abusing-laps
