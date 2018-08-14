Get-Service | Out-File "C:\Users\Public\Documents\Testoutput.txt"
install-windowsfeature Web-Server, web-mgmt-console
Import-Module WebAdministration
Set-Location IIS:\SslBindings
New-WebBinding -Name "Default Web Site" -IP "*" -Port 8080 -Protocol http
New-WebBinding -Name "Default Web Site" -IP "*" -Port 443 -Protocol https
$c = New-SelfSignedCertificate -DnsName "myexample.com" -CertStoreLocation cert:\LocalMachine\My
$c = New-Item 0.0.0.0!443