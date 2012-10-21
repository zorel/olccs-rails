# Historique

Au commencement était onlineCoinCoin (olcc). Client tribune pour le web écrit en javascript, nécessitant du PHP côté serveur (pour
palier l'impossibilité pour du javascript de faire une requete http ailleurs que sur son serveur d'origine).

Les 2 principaux fichiers PHP, backend.php et post.php effectuaient les requêtes vers les tribunes, en gérant les cookies,
les préférences, etc.

Le mode de fonctionnement avait pour effet de répercuter les problèmes des différentes tribunes directement à olcc, par
exemple les timeout et les ralentissements.

# Présentation

Online Coincoin Server permet de remplacer les backend.php et post.php en ajoutant une couche serveur qui va chercher
les remote.xml des différentes tribunes et remet à disposition des backend en json ou xml, en plus d'autres fonctionnalités.

Les fonctionnalités prévues ou implémentées sont (en vrac):

- normalisation des remotes (xml tags non encodés) *done*
- authentification par services tiers (openid/twitter/etc.) *done*
- sauvegarde/restauration des cookies *done*
- gestion de filtres/règles personnels sur les messages en entrée (lors de la lecture du backend) ou en sortie (lors de la génération) *done*
- gestion des substitutions dynamiques (par exemple #{totoz:boobs} pour avoir un totoz aléatoire de boobs)
- historique et indexation du contenu des URL, avec remote.xml des URL postées par tribune, et pour toutes les tribunes configurées *done*
- une page d'archive des url avec preview
- des jolis graphes pour des stats (répartition par jour/heure, etc)
- gestion des tags sur les urls
- envoi de contenu par mail (pour partage à partir d'un smartphone)
- backend multitribunes

Les buts sont de palier les problèmes de lenteur de certaines tribunes et de fournir un accès via recherche plein texte
pour les posts et le contenu des url postées.

On pourra par exemple avoir des bigornophones cross tribunes, des bloub detector
de pointe, tout en ayant un rendu rapide des remote sur les tribunes les plus lentes, et ainsi éviter le croixroutage
dans olcc, et améliorer la charge sur les serveurs legacy par la baisse du nombre des requêtes.

Online Coincoin Server est composé de:

- une application rails composée de:
  - une partie de gestion des tribunes (génération des remotes, refresh, recherche)
  - une partie de gestion des urls (stockage et indexation, recherche)
  - une partie utilisateur (connexion, sauvegarde/restauration du cookie, gestion des filtres/règles)
- un serveur elasticsearch
  - un index par tribune
  - un type post pour les posts. Configuré pour le français dans le contenu des messages
  - un type url pour les... urls (dont leur contenu pour la recherche)

## Disclaimer

Olccs a accès aux cookies stockés dans les préférences d'olcc. Forcément, il a en a besoin au moment du post d'un message.

Ces données ne sont pas conservées si vous n'utilisez pas la fonctionnalité de sauvegarde des cookies. La fonctionnalité
de sauvegarde utilise un système de chiffrage réversible (ROT13) pour la sécurisation extrême de vos cookies.

Les cookies ne sont pas loggués.

Ces cookies ne m'intéressent pas, ma passion n'étant pas de voler l'identité d'un inconnu pour aller poster un *I'm gay* sur
une tribune perdue sur le net.

Et pour finir, si ces tribunes étaient correctement codées, un simple cookie ne permettrait pas beaucoup plus que de poster
un message (et pas de changer un mot de passe par exemple). L'accès aux préférences et la possibilité de changer de mot de
passe devrait être protégé par une phase de login complète.


## The cake is a lie

"You just keep on trying 'till you run out of cake"
