---
hide:
  - navigation
---

# Secret du vote

Le comité électoral se réunit et co-crée un clé pour l'élection. Il faut qu'un
nombre suffisant de membre du comité soit présent pour pouvoir déchiffrer le
vote (par exemple, 3 parmis 5).

Votre votes est ensuite chiffré en utilisant la clé de l'élection.

Au moment du dépouillement, les votes sont agrégés en un résultat chiffrés
grace au propriétés du [chiffrement homomorphe](https://fr.wikipedia.org/wiki/Chiffrement_homomorphe).

Pour dépouiller l'élection, le comité électoral doit se réunir, et seul le
résultat est déchiffré.
