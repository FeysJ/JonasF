# DHCP SCRIPTS

1. Schrijf een script dat van alle DHCP scopes de ScopeID uitschrijft op het scherm
```
$scopes = Get-DhcpServer4Scope

ForEach ($scope in $scopes) {
  Write-Host $scope.ScopeId
  }
```
2. Schrijf een script dat voor alle DHCP scopes de Exclusion Ranges uitschrijft op het scherm. Geef hierbij voor elke exclusion range het start- en eindadres.

```
$scopes = Get-DhcpServerv4Scope
ForEach ($scope in $scopes){
    Write-Host "Scope $($scope.ScopeId)"
    $exclusions = Get-DhcpServerv4ExclusionRange -ScopeId $scope.ScopeId

   ForEach($exclusion in $exclusions){
    Write-Host "`t Exclusion: $($exclusion.StartRange) - $($exclusion.EndRange)"
    }
}
```

3. Schrijf een script dat voor alle DHCP scopes alle DHCP scope opties uitschrijft op het scherm. Geef hierbij voor elke optie het nummer en de waarde.

```
$scopes = Get-DhcpServerv4Scope

ForEach($scope in $scopes) {
    Write-Host "Scope $($scope.ScopeId)"
    $options = Get-DhcpServerv4OptionValue -ScopeId $scope.ScopeId

   ForEach($option in $options){
    Write-Host "`t Scope option: $($option.OptionId) - $($option.Value)"
    }
}
```

4. Schrijf een script dat voor elke DHCP scope een overzicht op het scherm geeft van de huidige leases. Geef hierbij voor elke lease het MAC-adres van de client en het toegekende IP-adres

```
$scopes = Get-DhcpServerv4Scope

ForEach($scope in $scopes) {
   Write-Host "Scope $($scope.ScopeId)"
   $leases = Get-DhcpServerv4Lease -ScopeId $scope.ScopeId

   ForEach($lease in $leases) {
      Write-Host "`t Lease: $($lease.ClientId) - $($lease.IPAddress)"
    }
}
```

5. Schrijf een script dat voor elke DHCP scope een overzicht op het scherm geeft van de huidige reservaties. Geef hierbij voor elke reservatie de naam van de reservatie, het MAC-adres van de client en het gereserveerde IP-adres.
```
$scopes = Get-DhcpServerv4Scope

foreach($scope in $scopes) {
   Write-Host "Scope $($scope.ScopeId)"
   $reservations = Get-DhcpServerv4Reservation -ScopeId $scope.ScopeId

   foreach($reservation in $reservations) {
      Write-Host "`t Reservation: $($reservation.Name) - $($reservation.ClientId) - $($reservation.IPAddress)"
   }
}
```

6. Schrijf een script dat de volgende 10 reservaties aanmaakt in de scope 192.168.0.0:

    * X krijgt een waarde van 1 tot 10
    * Naam reservatie: LaptopX
    * IP-adres reservatie: 192.168.0.<100 + X>
    * Mac-adres: 00-11-22-33-44-<50 + X>
    * Dus: laptop1 -> 192.168.0.101 met Mac-adres 00-11-22-33-44-51, enzovoort
```
for($i=1; $i -le 10; $i++){
   $naam = "Laptop$i"
   $ip = "192.168.0.$(100+$i)"
   $mac = "00-11-22-33-44-$(50+$i)"
   Add-DhcpServerv4Reservation -ScopeId 192.168.0.0 -IPAddress $ip -Name $naam -ClientId $mac
}
```

7. Die voorgaande verwijderd

```
for($i=1; $i -le 10; $i++){
   $mac = "00-11-22-33-44-$(50+$i)"
   Remove-DhcpServerv4Reservation -ScopeId 192.168.0.0 -ClientId $mac
}
```
