# Testrapport Opdracht: URL redirections dozer

## Test

Uitvoerder(s) test: Jonas Feys
Uitgevoerd op: 21/05/2023
Github commit:  COMMIT HASH

### testrapport

* Surf op de client naar <http://dozer.thematrix.local>. De Redmine website moet omleiden naar <https://dozer.thematrix.local>.
    > RESULTAAT: werking ok, redirect naar <https://dozer.thematrix.local>.
* Surf op de client naar <http://dozer.thematrix.local/projects>. De Redmine website moet omleiden naar <https://dozer.thematrix.local/projects>.
    > RESULTAAT: werking ok, redirect naar <https://dozer.thematrix.local/projects>.
* Surf op de client naar <http://www.dozer.thematrix.local>. De Redmine website moet omleiden naar <https://dozer.thematrix.local>.
    > RESULTAAT: RESULTAAT: werking ok, redirect naar <https://dozer.thematrix.local>.
* Surf op de client naar <http://www.dozer.thematrix.local/projects>. De Redmine website moet omleiden naar <https://dozer.thematrix.local/projects>.
    > RESULTAAT: werking ok, redirect naar <https://dozer.thematrix.local/projects>.
* Surf op de client naar <https://dozer.thematrix.local>. De website zal niet omleiden.
    > RESULTAAT: werking ok, gaat naar <https://dozer.thematrix.local>.
* Surf op de client naar <https://www.dozer.thematrix.local>. De Redmine website moet omleiden naar <https://dozer.thematrix.local>.
    > RESULTAAT: Geen redirect, gaat naar <https://www.dozer.thematrix.local>. Op zich is dit wel ok. 
* Surf op de client naar <https://www.dozer.thematrix.local/projects>. De Redmine website moet omleiden naar <https://dozer.thematrix.local/projects>.
    > RESULTAAT: Geen redirect, gaat naar <https://www.dozer.thematrix.local/projects>. Op zich is dit wel ok. 
