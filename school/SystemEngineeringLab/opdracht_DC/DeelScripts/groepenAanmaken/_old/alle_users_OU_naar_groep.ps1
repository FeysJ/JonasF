**Verwijder mij** 

# De bedoeling van dit script is om een groep te maken van alle users in een OU, eventueel met een uitzondering.
# Concreet vb.: alle leden van de OU "Cast" moeten in een groep "GRP_Cast komen"

New-ADGroup -Name "GRP_Cast" -SamAccountName GRP_Cast -GroupCategory Security -GroupScope Global -DisplayName "GRP_Cast" -Path "OU=Cast,OU=DomainUsers,DC=TheMatrix,DC=local" -Description "Alle leden van de Cast OU"
Get-ADUser -SearchBase ‘OU=Cast,OU=DomainUsers,DC=TheMatrix,DC=local’ -Filter * | ForEach-Object {Add-ADGroupMember -Identity ‘GRP_Cast’ -Members $_ }

New-ADGroup -Name "GRP_Crew" -SamAccountName GRP_Crew -GroupCategory Security -GroupScope Global -DisplayName "GRP_Crew" -Path "OU=Crew,OU=DomainUsers,DC=TheMatrix,DC=local" -Description "Alle leden van de crew"
Get-ADUser -SearchBase ‘OU=Crew,OU=DomainUsers,DC=TheMatrix,DC=local’ -Filter * | ForEach-Object {Add-ADGroupMember -Identity ‘GRP_Crew’ -Members $_ }

New-ADGroup -Name "GRP_Directors" -SamAccountName GRP_Directors -GroupCategory Security -GroupScope Global -DisplayName "GRP_Directors" -Path "OU=Directors,OU=Crew,OU=DomainUsers,DC=TheMatrix,DC=local" -Description "Alle directors"
Get-ADUser -SearchBase ‘OU=Directors,OU=Crew,OU=DomainUsers,DC=TheMatrix,DC=local’ -Filter * | ForEach-Object {Add-ADGroupMember -Identity ‘GRP_Directors’ -Members $_ }

# New-ADGroup -Name "GRP_Crew_not_directors" -SamAccountName GRP_Crew_not_directors -GroupCategory Security -GroupScope Global -DisplayName "GRP_Crew_not_directors" -Path "OU=Crew,OU=DomainUsers,DC=TheMatrix,DC=local" -Description "Alle leden van de crew, behalve de directors"
# Get-ADUser -SearchBase ‘OU=Crew,OU=DomainUsers,DC=TheMatrix,DC=local’ -Filter * | Where-Object { ($_.DistinguishedName -notlike "*OU=Directors*") } | ForEach-Object {Add-ADGroupMember -Identity ‘GRP_Crew_not_directors’ -Members $_ }
