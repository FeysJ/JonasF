# Testplan Opdracht Dozer: Redirections

Auteur(s) testplan: Lara Van Wynsberghe

## Startsituatie

* De server Dozer werd geïnstalleerd
* De DNS-server (op de DC) is bereikbaar en up to date
* Een test-client werd reeds geïnstalleerd
* De test client kan connecteren naar de Dozer

## Acties + verwachte resultaten

* Surf op de client naar <http://dozer.thematrix.local>. De Redmine website moet omleiden naar <https://dozer.thematrix.local>.
    > RESULTAAT:
* Surf op de client naar <http://dozer.thematrix.local/projects>. De Redmine website moet omleiden naar <https://dozer.thematrix.local/projects>.
    > RESULTAAT:
* Surf op de client naar <http://www.dozer.thematrix.local>. De Redmine website moet omleiden naar <https://dozer.thematrix.local>.
    > RESULTAAT:
* Surf op de client naar <http://www.dozer.thematrix.local/projects>. De Redmine website moet omleiden naar <https://dozer.thematrix.local/projects>.
    > RESULTAAT:
* Surf op de client naar <https://dozer.thematrix.local>. De website zal niet omleiden.
    > RESULTAAT:
* Surf op de client naar <https://www.dozer.thematrix.local>. De Redmine website moet omleiden naar <https://dozer.thematrix.local>.
    > RESULTAAT:
* Surf op de client naar <https://www.dozer.thematrix.local/projects>. De Redmine website moet omleiden naar <https://dozer.thematrix.local/projects>.
    > RESULTAAT:
