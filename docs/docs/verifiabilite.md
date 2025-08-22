---
hide:
  - navigation
---

# Vérifiabilité

Le processus de vote est entièrement vérifiable, garantissant la transparence
et l'intégrité du scrutin. La vérifiabilité se décline en plusieurs variantes :

## Vérifiabilité individuelle

Chaque électeur peut s'assurer que son vote a bien été pris en compte
conformément à son choix exprimé dans l'interface. Cette garantie repose
notamment sur la possibilité d'auditer le logiciel afin de vérifier qu'il
fonctionne correctement.

## Vérifiabilité universelle

Elle permet à toute personne, même extérieure au processus électoral, de
vérifier que le résultat final correspond exactement à l'ensemble des votes
exprimés.

1. Vérification que les bulletins de votes sont bien formés sans dévoiler leur
   contenu via l'utilisation de preuves zero-knowledge.
2. Vérification que l'agrégation des votes est correcte en refaisant le calcul.
3. Vérification des preuves de déchiffrement.

## Vérifiabilité de l'éligibilité

Seules les personnes invitées à l'élection peuvent voter. Pour ce faire, les
bulletins sont signés avec le credential du votant. Cela permet d'éviter tout
bourrage d'urne.
