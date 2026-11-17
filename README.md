# Pipeline de données en temps réel · ForceN (Groupe A)

Projet de groupe réalisé dans le cadre de la certification en Data Engineering de ForceN (mars – août 2026) : un pipeline complet qui collecte des données Twitter/X en temps réel, les transporte, les stocke, les analyse et les visualise.

Durée du projet : du 8 au 24 juillet 2026.

## Objectif

Construire de bout en bout une chaîne de traitement de données : de la collecte à la visualisation, avec des outils utilisés en data engineering.

## Architecture

```
Twitter/X  →  Python  →  Apache Kafka (Docker)  →  Apache Hive  →  Snowflake  →  Apache Superset
(collecte)   (producer)   (transport en continu)    (stockage/        (entrepôt      (tableau de bord)
                                                     traitement)       analytique)
```

| Étape | Outil | Rôle |
|---|---|---|
| Collecte | Python | Récupération des données Twitter/X en temps réel |
| Transport | Apache Kafka, Docker | Acheminement des données en continu |
| Stockage et traitement | Apache Hive | Stockage transitoire et traitement |
| Entrepôt de données | Snowflake | Stockage analytique |
| Visualisation | Apache Superset | Tableau de bord et rapports |

## Contenu du dépôt

| Fichier | Description |
|---|---|
| `[script_producer].py` | Producer Kafka : collecte et envoi des données |
| `[script_cons_hive].py` | Consumer : lecture depuis Kafka et chargement dans Hive |
| `hive.sql` | Création des tables et requêtes Hive |
| `[rapport_final].html` | Rapport final du projet |

## Résultats

[Complète avec ce que tu peux affirmer : ce que montre le tableau de bord, le volume de données traité, les difficultés rencontrées. Si tu n'as pas de chiffre sûr, décris simplement ce que le pipeline permet de faire.]

## Comment l'exécuter

Voir le rapport pour la procédure détaillée 

**Remarque sur la configuration :** les clés d'API, identifiants et mots de passe (Twitter/X, Snowflake) ont été retirés du code. Il faut les renseigner avec vos propres accès.

## Données

Les données collectées sur Twitter/X ne sont pas incluses dans ce dépôt.

## Équipe (Groupe A)

- Mouhamad Saadik PERKOUMA : visualisation (tableau de bord), rédaction du rapport, coordination du groupe
-
-
-
-


## Contexte

Projet réalisé dans le cadre de la certification en Data Engineering de ForceN.

## Auteur

Mouhamad Saadik PERKOUMA
[LinkedIn : https://www.linkedin.com/in/mouhamad-saadik-perkouma-0a359a2b8/]
