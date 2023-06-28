#Aanmaken van OUs TheMatrix.local

New-ADOrganizationalUnit -name "DomainWorkstations"
    New-ADOrganizationalUnit -name "PCs" -path "OU=DomainWorkstations,DC=TheMatrix,DC=local"
        New-ADOrganizationalUnit -name "Cast" -path "OU=PCs,OU=DomainWorkstations,DC=TheMatrix,DC=local"
        New-ADOrganizationalUnit -name "Crew" -path "OU=PCs,OU=DomainWorkstations,DC=TheMatrix,DC=local"
            New-ADOrganizationalUnit -name "Directors" -path "OU=Crew,OU=PCs,OU=DomainWorkstations,DC=TheMatrix,DC=local"
    New-ADOrganizationalUnit -name "Servers" -path "OU=DomainWorkstations,DC=TheMatrix,DC=local"

New-ADOrganizationalUnit -name "DomainUsers"
    New-ADOrganizationalUnit -name "Cast" -path "OU=DomainUsers,DC=TheMatrix,DC=local"
    New-ADOrganizationalUnit -name "Crew" -path "OU=DomainUsers,DC=TheMatrix,DC=local"
        New-ADOrganizationalUnit -name "Directors" -path "OU=Crew,OU=DomainUsers,DC=TheMatrix,DC=local"
        New-ADOrganizationalUnit -name "Producers" -path "OU=Crew,OU=DomainUsers,DC=TheMatrix,DC=local"

# VerFraaiing
# nog controles uitvoeren of de OU reeds bestaat vooraleer cmd uit te voeren
# Slaag er niet in om de OUs terug te delete-en. Geen rechten en OUs zijn beschermd tegen accidental deletion
# Kan ook via CsV bestand maar stond niet in Opgave