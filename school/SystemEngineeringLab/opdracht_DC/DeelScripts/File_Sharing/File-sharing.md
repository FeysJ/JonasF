# Fileshares gebruiken via Powershell

## Fileshare aanmaken in virtualbox

## Fileshare openen op de DC

1. Maak een oplijsting van alle drives op de VM: `Get-PSDrive`
2. De naam van de netwerkdrive zal ongeveer "\\VBoxSvr\naam-van-de-map" zijn, gekoppeld aan de Z-schijf. Ga naar deze schijf d.m.v. het commando `cd Z:`
3. Lijst de bestanden in deze map op, d.m.v. het commando `dir`
4. Ga naar de map met de gedeelde installatie-scripts en voer deze in de juiste volgorde uit.

## GPO die fileshares automatisch mapt

De uitleg hierrond kan teruggevonden worden in <opdracht_DC/GPO/GPOs.md>, onderaan.
