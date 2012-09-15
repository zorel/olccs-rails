# Site

Le menu du site présente toujours au moins 5 parties:
- Olccs, le lien de retour à la racine
- Olcc, le lien pour aller au olcc intégré
- Le menu déroulant de gestion utilisateur
- L'aide
- Le lien d'À Propos.

## /

### backend.php / post.php / totoz.php / attach.php

Compatibilité avec olcc genuine edition (la seule pour l'instant en activité cela dit).

### urls.rss / urls.xml

Flux rss / remote.xml présentant les 42 dernières URLs postées sur l'ensemble des tribunes d'OLCCS

## /t/tribune

Possède forcément le nom de la tribune: /t/euromussels ou /t/dlfp

### /

Présente l'interface web de la tribune. La pagination est disponible pour naviguer dans l'ensemble de l'historique d'une tribune.
Les fonctionnalités d'une tribune web normale sont disponibles (highlight, gestion du clic, totoz, etc.).

### /search

Interface de recherche sur la tribune. Recherche à la fois dans les posts et le contenu des urls.

Une requête en HTTP POST sur search.xml permet de récupérer un remote.xml correspondant aux résultats.

### /stats

Des statistiques sur la tribune, avec graphiques pour répartitions horaires, quotidiennes, hebdo, etc.

### /remote.tsv / /remote.xml

Les remotes de la tribune, au format Tab Separated Value et remote.xml.

Gère la pagination par page de 150 éléments avec le paramètre page.

Gère la génération d'un remote.xml limité par la gestion du paramètre last_id.

### /post

Permet le post sur la tribune. Envoi l'intégralité des cookies reçus vers la tribune cible. Gère le X-Post-Id s'il est
renvoyé.

### /login

Permet le login sur la tribune distance pour peu que la configuration inclue l'URL de login et le nom des paramètres login/password.

Gère les paramètres user et password pour les informations de login.

## /u

Une fois connecté via le menu déroulant, ces pages sont accessibles. Sinon, l'utilisateur est redirigé vers la racine.

### /edit_rules

Permet l'édition des règles à lancer sur les posts au moment de la génération des remotes. Ces filtres sont lancés dans la
partie qui génère la liste des posts, et par conséquent les remote.xml, tsv, backend.php et pages web utilisent ces filtres.

La partie Query est à écrire en syntaxe lucene: https://lucene.apache.org/core/3_6_1/queryparsersyntax.html .

### /save_olcc_cookie / /destroy_olcc_cookie

Sauvegarde et supprime les cookies de configuration olcc pour l'utilisateur connecté. Permet de récupérer ses cookies ailleurs
sans forcément avoir à utiliser des modules navigateurs spécifiques.
