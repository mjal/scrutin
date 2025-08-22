---
hide:
  - navigation
---

# Extension pour l'éligibilité (en cours de développement)

Scrutin souhaiterait supporter l'ajout et la suppression de participants en cours d'élection.

## Tour d'horizon

Dans Belenios, chaque élection possède sa propre base de données, sous la forme d'un fichier TAR. Il est uniquement possible d'ajouter des données à la base de données, jamais d'en supprimer, ce qui est utile pour la transparence. Les données ajoutables sont appelées "événements".

## Changement

Un nouvel événement **UpdateCredentials** est prévu.

Il permet à l'administrateur d'une élection d'ajouter ou révoquer des codes de vote en cours d'élection.

## Compatibilité avec Belenios

Afin de permettre la compatibilité avec Belenios, il est prévu de pouvoir exporter une base de données ne contenant que les événements supportés par Belenios, avec les credentials mis à jour.
