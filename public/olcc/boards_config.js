/************************************************************
 * OnlineCoinCoin, by Chrisix (chrisix@gmail.com)
 * Définition des tribunes préconfigurées
 ************************************************************/

var dlfp = new Board('dlfp', false);
dlfp.getUrl = 'http://linuxfr.org/board/index.xml?last=%i';
dlfp.postUrl = 'http://linuxfr.org/board';
dlfp.postData = "board[message]=%m";
dlfp.alias = "linuxfr,beyrouth,passite,dapassite";
dlfp.cookie = '_linuxfr.org_session=';
GlobalBoards['dlfp'] = dlfp;

var batavie = new Board('batavie', false);
batavie.getUrl = 'http://batavie.leguyader.eu/remote.xml?last=%i';
batavie.postUrl = 'http://batavie.leguyader.eu/index.php/add';
batavie.color = '#ffccaa';
batavie.alias = "llg";
GlobalBoards['batavie'] = batavie;

var euro = new Board('euromussels', false);
euro.getUrl = 'http://euromussels.eu/?q=tribune.xml&last=%i';
euro.postUrl = 'http://euromussels.eu/?q=tribune/post';
euro.color = '#d0d0ff';
euro.alias = "euro,euroxers";
GlobalBoards['euromussels'] = euro;

var see = new Board('see', false);
see.getUrl = 'http://tout.essaye.sauf.ca/tribune.xml?last=%i';
see.postUrl = 'http://tout.essaye.sauf.ca/tribune/post';
see.color = '#ffd0d0';
see.alias = "schee,seeschloss";
GlobalBoards['see'] = see;

var moules = new Board('moules', false);
moules.getUrl = 'http://moules.org/board/backend?last=%i';
moules.postUrl = 'http://moules.org/board/add';
moules.color = '#ffe3c9';
GlobalBoards['moules'] = moules;

var bouchot = new Board('bouchot', false);
bouchot.getUrl = 'http://bouchot.org/tribune/remote?last=%i';
bouchot.postUrl = 'http://bouchot.org/tribune/post_coincoin';
bouchot.postData = "missive=%m";
bouchot.color = '#e9e9e9';
GlobalBoards['bouchot'] = bouchot;

var finss = new Board('finss', false);
finss.getUrl = 'http://finss.free.fr/drupal/?q=tribune.xml&last=%i';
finss.postUrl = 'http://finss.free.fr/drupal/?q=tribune/post';
finss.color = '#d0ffd0';
GlobalBoards['finss'] = finss;

var shoop = new Board('shoop', false);
shoop.getUrl = 'http://dax.sveetch.net/tribune/remote.xml?last=%i'; // ?last=%i inopérant pour le moment
shoop.postUrl = 'http://dax.sveetch.net/tribune/post.xml';
shoop.postData = "content=%m";
shoop.alias = "sveetch,dax";
shoop.color = '#EDEDDB';
GlobalBoards['shoop'] = shoop;

var tif = new Board('jplop', false);
tif.getUrl = 'http://catwitch.eu/jplop/backend';
tif.postUrl = 'http://catwitch.eu/jplop/post';
tif.postData = "message=%m";
tif.alias = "tif";
tif.color = '#a9f9b9';
GlobalBoards['jplop'] = tif;

var olo = new Board('olo', false);
olo.getUrl = 'http://board.olivierl.org/remote.xml';
olo.postUrl = 'http://board.olivierl.org/add.php';
olo.color = '#80dafc';
olo.alias = "olivierl";
GlobalBoards['olo'] = olo;

var ygllo = new Board('ygllo', false);
ygllo.getUrl = 'http://ygllo.com/?q=tribune.xml';
ygllo.postUrl = 'http://ygllo.com/?q=tribune/post';
ygllo.color = '#eee887';
ygllo.alias = "yg,llo,fdg";
GlobalBoards['ygllo'] = ygllo;

var kad = new Board('kadreg', false);
kad.getUrl = 'http://kadreg.org/board/backend.php';
kad.postUrl = 'http://kadreg.org/board/add.php';
kad.color = '#dae6e6';
kad.alias = "kad,rincevent";
GlobalBoards['kadreg'] = kad;

var dae = new Board('darkside', false);
dae.getUrl = 'http://quadaemon.free.fr/remote.xml';
dae.postUrl = 'http://quadaemon.free.fr/add.php';
dae.color = '#daedae';
dae.alias = "dae,daemon";
GlobalBoards['darkside'] = dae;

var axel = new Board('hadoken', false);
axel.getUrl = 'http://hadoken.free.fr/board/remote.php';
axel.postUrl = 'http://hadoken.free.fr/board/post.php';
axel.color = '#77AADD';
axel.alias = "axel,waf";
GlobalBoards['hadoken'] = axel;

var lo = new Board('comptoir', false);
lo.getUrl = 'http://lordoric.free.fr/daBoard/remote.xml';
lo.postUrl = 'http://lordoric.free.fr/daBoard/add.php';
lo.color = '#dedede';
lo.alias = "lo,lordoric";
GlobalBoards['comptoir'] = lo;

var gabu = new Board('gabuzomeu', false);
gabu.getUrl = 'http://gabuzomeu.fr/tribune.xml';
gabu.postUrl = 'http://gabuzomeu.fr/tribune/post';
gabu.color = '#aaffbb';
GlobalBoards['gabuzomeu'] = gabu;
