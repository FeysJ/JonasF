# Testrapport (eerste versie)

## Test y

Uitvoerder(s) test: NAAM
Uitgevoerd op: DATUM
Github commit:  COMMIT HASH

### Eerste testen van Joost (voorafgaand aan uniformisering testplan en testrapport)

De volgende testresultaten werden reeds besproken en verholpen:

- Een exit is beter indien het iso-path niet bestaat
- Naam is beter niet refererend naar iso
- Ook path van de vdi aangeven en testen via controleerIso
- Nog één error die ik niet vind
    Deze error komt niet indien je binnen terminal visual studio code de code uitvoert:
    De error komt wanneer je via powershellISE het script uitvoert
    de hd wordt : D:\TILE2\system engineering project\downloads\hallo.vdi
    VBoxManage : 0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
    At line:66 char:1
    + VBoxManage createmedium `
    + ~~~~~~~~~~~~~~~~~~~~~~~~~
            + CategoryInfo          : NotSpecified: (0%...10%...20%....0%...90%...100%:String) [], RemoteException
            + FullyQualifiedErrorId : NativeCommandError

    Medium created. UUID: 7a3ec2ab-e4d2-4404-90ad-07dc11176a5e  
- Nog wijzigen zodat er naar een file gezocht wordt bij check van iso-bestand

