* Welcome to Online CoinCoin Server - Rails edition

Online Coincoin Server permet de remplacer les backend.php et post.php en ajoutant une couche serveur qui va chercher
les remote.xml des différentes tribunes et remet à disposition des backend en json ou xml, en plus d'autres fonctionnalités.

Les fonctionnalités prévues ou implémentées sont (en vrac):

- normalisation des remotes (xml tags non encodés)
- authentification par services tiers (openid/twitter/etc.)
- sauvegarde/restauration des cookies
- gestion de filtres/règles personnels sur les messages en entrée (lors de la lecture du backend) ou en sortie (lors de la génération)
- gestion des substitutions dynamiques (par exemple #{totoz:boobs} pour avoir un totoz aléatoire de boobs)
- historique et indexation du contenu des URL, avec remote.xml des URL postées par tribune, et pour toutes les tribunes configurées
- gestion des tags sur les urls
- envoi de contenu par mail (pour partage à partir d'un smartphone)

Les buts sont de palier les problèmes de lenteur de certaines tribunes et de fournir un accès via recherche plein texte pour les posts et le contenu des url postées.

On pourra par exemple construire des backends multitribunes, avoir des bigornophones cross tribunes, des bloub detector de pointe, tout en ayant un rendu rapide des remote sur les tribunes les plus lentes, et ainsi éviter le croixroutage dans olcc, et améliorer la charge sur les serveurs legacy par la baisse du nombre des requêtes.

Online Coincoin Server est composé de:

- une application rails composée de:
  - une partie de gestion des tribunes (génération des remotes, refresh, recherche)
  - une partie de gestion des urls (stockage et indexation, recherche)
  - une partie utilisateur (connexion, sauvegarde/restauration du cookie, gestion des filtres/règles)
- un serveur elasticsearch
  - un index par tribune
  - un type post pour les posts. Configuré pour le français dans le contenu des messages
  - un type url pour les... urls (dont leur contenu pour la recherche)

