# GPO's

Open op de DirectorPC het Groepsbeleidsbeheer menu.
Alle GPOs staan onder "Groepsbeleidsobjecten" in het doemin TheMatrix.local

## Disable local users

Pas volgende aan

1. Klik op "CPT_disable_local_accounts"
2. Ga in het hoofdmenu bij "Delegering" naar Geavanceerd en voeg de Computer AGENTSMITH toe. Je dient objecttype Computers ook aan te vinken om deze te vinden. 
3. Bij machtigingen, vink "Weigeren" aan  bij "Groepsbeleid toepassen". </br>
![Delegeren: uitzondering voor Agentsmith](./Images/CPT-disable_local_accounts/CPT-disable_local_accounts-delegering.png?raw=true "Delegeren: uitzondering voor Agentsmith")
4. Toestaan van GPO bij geverifieerde gebruikers
![Delegeren: Toepassen op andere domain workstations](./Images/CPT-disable_local_accounts/CPT-disable_local_accounts-delegering2.png?raw=true "Delegeren: Toepassen op andere domain workstations")
5. Koppel de GPO aan de DomainWorkstations
![GPO koppelen](./Images/CPT-disable_local_accounts/CPT-disable_local_accounts-koppelen.png?raw=true "GPO koppelen")

## Gebruikersbeleid

### USR_prevent-access-control-panel

1. Pas de volgende delegering toe:
    * Groepsbeleid toepassen op "Geverifieerde gebruikers" (zou reeds ok moeten zijn)
    * Groepsbeleid toepassen WEIGEREN op de groep GRP_Directors
![Delegering 1](./Images/USR_prevent-access-control-panel/USR_prevent-access-control-panel-delegering1.png?raw=true "Delegering 1") </br>
![Delegering 2](./Images/USR_prevent-access-control-panel/USR_prevent-access-control-panel-delegering2.png?raw=true "Delegering 2")

