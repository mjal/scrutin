---
hide:
  - navigation
---

# Extension (en cours de développement)

Scrutin souhaite supporter l'ajout et la suppression de participants en cours d'élection.

## Tour d'horizon

Dans Belenios, chaque élection possède sa propre base de donnée, sous la forme d'un fichier TAR. Il est uniquement possible d'ajouter des données à la base de donnée, jamais d'en supprimer, ce qui est utile pour la transparence. Les données ajoutables sont appelés "événements".

## Changement

Un nouvel événement **UpdateCredentials** est prévu.

Il permet à l'administateur d'une élection d'ajouter ou révoquer des codes de vote en cours d'élection.

## Compatibilité avec Belenios

Afin de permettre la vérification de l'élection par Belenios, il est prévu qu'une base de donnée modifiée pour ne contenir que les événements supportés par Belenios, avec les credentials mis à jours, puisse être généré.
