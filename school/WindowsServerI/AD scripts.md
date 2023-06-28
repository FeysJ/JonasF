# AD SCRIPTS

1. Schrijf een script dat aan de gebruiker vraagt om de naam van OU in te geven (bijvoorbeeld: PersoneelGent). Nadien schrijft het script voor elke OU met deze naam het volledige pad uit in X500 (LDAP) formaat.
   
```
[string] $naam = Read-Host -Prompt "Geef naam OU"
$ous = Get-ADOrganizationalUnit -Filter 'Name -like $naam'

foreach($ou in $ous){
   Write-Host $ou.DistinguishedName
}
```
2. Schrijf een script dat aan de gebruiker vraagt om een getal in te geven (bijvoorbeeld: 10). Nadien maakt het script een aantal OUs aan onder de root van het domein, met als naam test1, test2, … tot en met test10 (als de gebruiker als getal 10 ingaf). Zorg dat bij aanmaken van de OUs de bescherming tegen verwijderen uit staat.

```
[int] $aantal = Read-Host "Hoeveel OUs wil je aanmaken"

for($i=1; $i -le $aantal; $i++){
New-ADOrganizationalUnit -Name "test$i" -ProtectedFromAccidentalDeletion $false
}
```

3. Idem als de vorige vraag, maar de OUs worden genest aangemaakt: test1 wordt aangemaakt onder de root van het domein, test2 wordt aangemaakt als kind OU van test1, test3 is een kind OU van test2 enzovoort.

```
[int] $aantal = Read-Host "Hoeveel OUs wil je aanmaken" $locatie = "DC=hogent,DC=local"

for($i=1; $i -le $aantal; $i++){
   New-ADOrganizationalUnit -Name "test$i" -ProtectedFromAccidentalDeletion $false -Path $locatie
   $locatie = "OU=test$($i),$locatie"
}
```

4. Schrijf een script dat aan de gebruiker vraagt om een gebruikersnaam in te geven (bijvoorbeeld: mad_sme). Nadien schrijft het script het volledige pad uit van deze gebruiker in X500 (LDAP) formaat.

```
$user = Get-ADUser -Identity $naam
Write-Host $user.DistinguishedName
```

5. Bij het aanmaken van een gebruiker kan je de optie `-SamAccountName` gebruiken om de gebruikersnaam in te stellen. Dit stelt enkel de gebruikersnaam in voor het oude (NetBIOS) formaat (bv. HOGENT\jdoe) en niet voor het nieuwe AD formaat (bv. jdoe@hogent.local). Zoek uit met welke optie je dit laatste kan instellen, en test dit uit.
   
```
# Hiervoor kan je de optie -UserPrincipalName gebruiken. Voorbeeld: 

New-ADUser -SamAccountName "jdoe" -UserPrincipalName "jdoe@hogent.local" -Name "John Doe"
```

6. Bij het aanmaken van een gebruiker kan je ook een wachtwoord instellen. Zoek uit hoe je dit kan doen, en test dit uit.

```
New-ADUser -Name "John Doe" -AccountPassword (ConvertTo-SecureString "Jon&Doe" -AsPlainText -force)
```

7. Schrijf een script dat aan de gebruiker vraagt om de naam van een AD groep in te geven (bv. Domain Admins). Nadien schrijft het script alle namen uit van de leden van deze groep.

```
[string] $naam = Read-Host -Prompt "Geef naam groep" 
$leden = Get-ADGroupMember -Identity $naam 

foreach($lid in $leden){
   Write-Host $lid.name 
}
```

8. 

Schrijf een script dat aan een gebruiker vraagt om de naam van een (nieuwe) groep in te geven, alsook een getal (bijvoorbeeld: 2C1 en 15). Op basis van deze 2 inputwaarden zal het script dan:
   * Een OU aanmaken onder de root met als naam de naam van de groep (bv. 2C1)
   * In deze OU een groep aanmaken met dezelfde naam (bv. 2C1) en als omschrijving OU voor <naam groep> (bv. OU voor 2C1).
   * In deze OU 15 gebruikers aanmaken met als gebruikersnaam <naam groep>_<nr> (bv. 2C1_1, 2C1_2, ..., 2C1_15) en deze gebruikers toevoegen aan de groep aangemaakt in het vorig puntje. Voor de gebruikers stel je zowel de NetBIOS accountnaam in, als de gebruikersnaam in het nieuwe formaat. Als naam voor de gebruikers gebruiker je <naam groep> gebruiker <nr> (bv. 2C1 gebruiker 1, 2C1 gebruiker 2, ...).
   * Controleer na uitvoeren van het script of de OU, de groep en de gebruikers correct aangemaakt zijn.

```
[string] $groep = Read-Host -Prompt "Naam groep"
[int] $aantal = Read-Host -Prompt "Aantal gebruikers"
$locatie = "DC=hogent,DC=local"

# Aanmaken OU
New-ADOrganizationalUnit -Name "$groep" -ProtectedFromAccidentalDeletion $false -Path $locatie

# Aanmaken groep in OU
New-ADGroup -Name "$groep" -Description "OU voor $groep" -Path "OU=$groep,$locatie" GroupScope Global

# Gebruikers aanmaken en toevoegen aan groep
for($i=1; $i -le $aantal; $i++){
   New-ADUser -Name "$groep gebruiker $i" -SamAccountName "$($groep)_$($i)" UserPrincipalName "$($groep)_$($i)@hogent.local" -Path "OU=$groep,$locatie"
   Add-ADGroupMember -Identity "$groep" -Members "$($groep)_$($i)"
}
```