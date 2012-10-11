# Gestion des formats

Certaines API peuvent génèrer plusieurs formats (html, rss, tsv, xml ou json). La sélection de ces formats se fait en fonction
de 2 mécanismes: le type mime et l'extension. La négociation de contenu via le header Accept en http permet de spécifier
quel type mime le client préfère recevoir. En fonction de ces paramètres, voici les formats renvoyés au client:

<table class="table">
    <thead>
        <tr>
            <th>Type mime</th>
            <th>Extension</th>
            <th>Format retourné</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>
                <ul>
                    <li>text/html</li>
                    <li>application/xhtml+xml</li>
                </ul>
            </td>
            <td>html</td>
            <td>HTML. Utilisé pour la partie Web du site.</td>
        </tr>
        <tr>
            <td>
                <ul>
                    <li>application/xml</li>
                    <li>text/xml</li>
                    <li>application/x-xml</li>
                </ul>
            </td>
            <td>xml</td>
            <td>XML, c'est à dire format remote.xml</td>
        </tr>
        <tr>
            <td>
                <ul>
                    <li>text/tsv</li>
                </ul>
            </td>
            <td>tsv</td>
            <td>Tab Separated Values. Format pour le remote, donc pour contenir une liste de posts</td>
        </tr>
        <tr>
            <td>
                <ul>
                    <li>application/rss+xml</li>
                </ul>
            </td>
            <td>rss</td>
            <td>Really Simple Syndication, utilisé pour les API de liste d'urls</td>
        </tr>
        <tr>
            <td>
                <ul>
                    <li>application/json</li>
                    <li>text/x-json</li>
                </ul>
            </td>
            <td>json</td>
            <td>JavaScript Object Notation. Non utilisé par les API pour le moment, juste pour le backend de la tribune Web</td>
        </tr>
    </tbody>
</table>

Exemples:

* /t/euromussels/remote.tsv => format tab separated value
* /t/euromussels/remote + Accept text/tsv => format tab separated value
* /t/euromussels/remote + Accept text/xml => format xml remote(.xml)



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
            <td>GET /boards.:format</td>
            <td>Une liste des tribunes au format discover, ou presque. Pour l'instant, seul le .xml est implémenté.</td>
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
