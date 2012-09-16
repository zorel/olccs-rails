# Site

Le menu du site présente toujours au moins 5 parties:

* Olccs, le lien de retour à la racine
* Olcc, le lien pour aller au olcc intégré
* Le menu déroulant de gestion utilisateur
* L'aide
* Le lien d'À Propos.

# Racine du site

<table class="table">
    <thead>
        <tr>
            <th>Ressource</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>/</td>
            <td>Page d'accueil du site, présente la liste des tribunes avec des informations, et le lien de recherche pour chacune d'entre elle</td>
        </tr>
        <tr>
            <td>/olcc</td>
            <td>Envoie vers l'olcc intégré</td>
        </tr>

    </tbody>
</table>

# Tribune

<table class="table">
    <thead>
        <tr>
            <th>Ressource</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>/t/:tribune</td>
            <td>Page d'accueil de la tribune présentant l'interface Web: liste des posts, pagination.</td>
        </tr>
        <tr>
            <td>/urls</td>
            <td>Présente les 42 dernières urls postées.</td>
        </tr>
        <tr>
            <td>/t/:tribune/search</td>
            <td>Permet d'effectuer une recherche sur la tribune.</td>
        </tr>
        <tr>
            <td>/t/:tribune/stats</td>
            <td>Des statistiques sur la tribune, plus gros posteurs, répartition temporelle, etc.</td>
        </tr>

    </tbody>
</table>

# Utilisateur

<table class="table">
    <thead>
        <tr>
            <th>Ressource</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>/u</td>
            <td>Page d'accueil de l'utilisateur. Nécessite d'être connecté</td>
        </tr>
        <tr>
            <td>/edit_rules</td>
            <td>
                Gestion des règles de filtrage sur les posts. 4 champs pour les règles:
                <ol>
                    <li>le nom de la règle. Doit être unique pour l'utilisateur</li>
                    <li>la query. <a href="http://www.lucenetutorial.com/lucene-query-syntax.html">Format Lucene</a></li>
                    <li>l'action a lancer sur le post en cas de match</li>
                    <li>la tribune sur laquelle activer le filtre.
                    <span class="label label-warning">Attention</span> Une règle ne peut être activée que sur une seule tribune</li>
                </ol>
                L'ajout et la suppression se font <span class="label label-important">uniquement</span> après validation
                du formulaire à l'aide du bouton submit.
            </td>
        </tr>
    </tbody>
</table>
