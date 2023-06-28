
# Laatste stappen voor installatie van exchange server


D:\Setup.exe /IAcceptExchangeServerLicenseTerms_DiagnosticDataOFF /PrepareSchema 
D:\Setup.exe /IAcceptExchangeServerLicenseTerms_DiagnosticDataOFF /PrepareAD /OrganizationName:"TheMatrix"
D:\Setup.exe /IAcceptExchangeServerLicenseTerms_DiagnosticDataOFF /PrepareAllDomains
D:\Setup.exe /m:install /roles:m /IAcceptExchangeServerLicenseTerms_DiagnosticDataOFF /InstallWindowsComponents



