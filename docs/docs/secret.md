---
hide:
  - navigation
---

# Secret du vote

Le bureau de vote se réunit pour générer la clé de l'élection. Il faut qu'un
nombre suffisant de membres du bureau soit présent pour pouvoir déchiffrer le
vote (par exemple, 3 parmi 5).

Les votes sont chiffrés avec la clé de l'élection.

Les votes sont ensuite agrégés grâce au [chiffrement
homomorphe](https://fr.wikipedia.org/wiki/Chiffrement_homomorphe).

Enfin, pour dépouiller l'élection, un nombre suffisant de membres doit se réunir
et émettre des déchiffrements partiels.
