---
hide:
  - navigation
---

# Vérifiabilité

Le processus de vote est entièrement vérifiable, garantissant la transparence et
l'intégrité du scrutin. La vérifiabilité se décline en plusieurs variantes :

## Vérifiabilité individuelle

Chaque électeur peut s'assurer que son vote a bien été pris en compte
conformément à son choix exprimé dans l'interface. Cette garantie repose
notamment sur la possibilité d'auditer le logiciel pour vérifier qu'il
fonctionne correctement.


## Vérifiabilité universelle

Elle permet à toute personne, même extérieure au processus électoral, de
vérifier que le résultat final correspond exactement à l'ensemble des
votes exprimés.

1. Vérification que les bulletins de votes sont bien formés sans dévoiler leur
   contenu via l'utilisation preuves à divulgation nulle de connaissance
   (Zero-Knowledge Proofs).
2. Vérification de l'agrégation des votes en refaisant le calcul.
3. Vérification que le déchiffrement est correct sans posséder les clés de
   déchiffrement, encore à l'aide de zero-knowldege proofs

Ce mécanisme repose sur plusieurs étapes de contrôle,
incluant notamment : La vérification des bulletins de vote.
L'utilisation de preuves à divulgation nulle de connaissance
(Zero-Knowledge Proofs), qui permettent de prouver que les bulletins
sont correctement formés (par path/to/your-file.mdexemple, qu'un électeur ne vote pas plus
de fois qu'autorisé), sans révéler le contenu des votes.

## Vérifiabilité de l'éligibilité

Seules les personnes invités à l'élection peuvent voter. On utilise pour ça des
signatures accolés aux bulletins de vote pour éviter tout bourrage de l'urne
accolés aux bulle de vote pour éviter tout bourrage de l'urne.
