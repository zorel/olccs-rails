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
            <td>GET /urls.:format</td>
            <td>Présente les 42 dernières urls postées sur l'ensemble des tribunes d'olccs. 2 formats: rss et xml</td>
        </tr>
        <tr>
            <td>backend.php post.php totoz.php attach.php</td>
            <td>API de compatibilité avec olcc</td>
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
            <td>GET /t/:tribune/remote.:format</td>
            <td>Le backend de la tribune, pour les coincoins. 2 formats: tsv (tab separated values) et xml (remote.xml)
                <table class="table">
                    <thead>
                        <tr>
                            <th>Paramètre</th>
                            <th>Description</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>page</td>
                            <td>Numéro de la page à générer</td>
                        </tr>
                        <tr>
                            <td>last</td>
                            <td>Génération du remote optimisé à partir de l'id last</td>
                        </tr>
                    </tbody>
                </table>
            </td>
        </tr>
        <tr>
            <td>GET /urls.:format</td>
            <td>Présente les 42 dernières urls postées. 2 formats: rss et xml</td>
        </tr>
        <tr>
            <td>GET /t/:tribune/search.:format</td>
            <td>Permet d'effectuer une recherche sur la tribune. 3 formats: tsv, xml et html.
                <table class="table">
                    <thead>
                        <tr>
                            <th>Paramètre</th>
                            <th>Description</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>query</td>
                            <td>Requête au format lucene.
                                <span class="label label-warning">Attention</span> si ce paramètre est absent, affichera l'interface
                                de recherche. Un GET sans query pour un coincoin ne renverra rien</td>
                        </tr>
                        <tr>
                            <td>page</td>
                            <td>Numéro de la page de résultats à afficher</td>
                        </tr>
                    </tbody>
                </table>

            </td>
        </tr>
        <tr>
            <td>POST /t/:tribune/post.:format</td>
            <td>Poste un message sur la tribune concernée. Olccs envoie tous les cookies présentés vers la tribune, ainsi que l'UA.
                Supporte 3 formats: html (retour vide dans ce cas), tsv et xml (retourne le backend pour ces 2 formats)
                <table class="table">
                    <thead>
                        <tr>
                            <th>Paramètre</th>
                            <th>Description</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>message</td>
                            <td>Le message au format "standard"</td>
                        </tr>
                        <tr>
                            <td>last</td>
                            <td>Pour les posts tsv et xml, ne retourne que les posts dont l'id est supérieur à last</td>
                        </tr>
                    </tbody>
                </table>
            </td>
        </tr>
         <tr>
            <td>POST /t/:tribune/login</td>
            <td>Permet le login sur la tribune. Retourne au format json les cookies renvoyés lors de la phase de login.
                <table class="table">
                    <thead>
                        <tr>
                            <th>Paramètre</th>
                            <th>Description</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>username</td>
                            <td>le login sur la tribune cible</td>
                        </tr>
                        <tr>
                            <td>password</td>
                            <td>le mot de passe</td>
                        </tr>
                    </tbody>
                </table>
            </td>
        </tr>
    </tbody>
</table>
