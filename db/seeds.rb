# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#Tribune.create(name: '',
#               refresh_interval: 15,
#               get_url: '',
#               last_id_parameter: '',
#               post_parameter: '',
#               post_url: '',
#               cookie_url: '',
#               cookie_name: '',
#               remember_me_parameter: '',
#               user_parameter: '',
#               pwd_parameter: ''
#)

Tribune.create(name: 'shoop',
               refresh_interval: 15,
               get_url: "http://dax.sveetch.net/tribune/remote/xml/",
               last_id_parameter: "last",
               post_parameter: "content",
               post_url: "http://dax.sveetch.net/tribune/post.xml",
               cookie_url: "http://dax.sveetch.net/accounts/login/",
               cookie_name: %w(shoop_sessionid),
               user_parameter: "username",
               pwd_parameter: "password")

Tribune.create(name: 'euromussels',
               refresh_interval: 15,
               get_url: "http://euromussels.eu/?q=tribune.xml",
               last_id_parameter: "last_id",
               post_parameter: "message",
               post_url: "http://euromussels.eu/?q=tribune/post",
               cookie_url: "http://euromussels.eu/tribune",
               cookie_name: %w(SESS.*),
               user_parameter: "name",
               pwd_parameter: "pass")

Tribune.create(name: 'dlfp',
               refresh_interval: 15,
               get_url: 'http://linuxfr.org/board/index.xml',
               last_id_parameter: '',
               post_parameter: 'board[message]',
               post_url: 'http://linuxfr.org/board',
               cookie_url: 'https://linuxfr.org/compte/connexion',
               cookie_name: '[linuxfr.org_session]',
               remember_me_parameter: 'account[remember_me]',
               user_parameter: 'account[login]',
               pwd_parameter: 'account[password]'
)

Tribune.create(name: 'moules',
               refresh_interval: 120,
               get_url: 'http://moules.org/board/backend',
               last_id_parameter: 'last_id',
               post_parameter: 'message',
               post_url: 'http://moules.org/board/add',
               cookie_url: 'http://moules.org/board',
               cookie_name: '[SESS.*]',
               remember_me_parameter: '',
               user_parameter: 'name',
               pwd_parameter: 'pass'
)

Tribune.create(name: 'see',
               refresh_interval: 120,
               get_url: 'http://tout.essaye.sauf.ca/tribune.xml',
               last_id_parameter: 'last_id',
               post_parameter: 'message',
               post_url: 'http://tout.essaye.sauf.ca/tribune/post',
               cookie_url: 'http://tout.essaye.sauf.ca/user/login',
               cookie_name: '[SESS.*]',
               remember_me_parameter: '',
               user_parameter: 'name',
               pwd_parameter: 'pass'
)

Tribune.create(name: 'batavie',
               refresh_interval: 120,
               get_url: 'http://batavie.leguyader.eu/remote.xml',
               last_id_parameter: 'last',
               post_parameter: 'message',
               post_url: 'http://batavie.leguyader.eu/index.php/add',
               cookie_url: 'http://batavie.leguyader.eu/user.php/login',
               cookie_name: '[unique_id, md5]',
               remember_me_parameter: '',
               user_parameter: 'login',
               pwd_parameter: 'passwd'
)

Tribune.create(name: 'bouchot',
               refresh_interval: 120,
               get_url: 'http://bouchot.org/tribune/remote',
               last_id_parameter: 'last',
               post_parameter: 'missive',
               post_url: 'http://bouchot.org/tribune/post_coincoin',
               cookie_url: 'http://bouchot.org/account/login',
               cookie_name: '[_tribune_session]',
               remember_me_parameter: '',
               user_parameter: 'login',
               pwd_parameter: 'password'
)

Tribune.create(name: 'jplop',
               refresh_interval: 120,
               get_url: 'http://catwitch.eu/jplop/backend',
               last_id_parameter: '',
               post_parameter: 'message',
               post_url: 'http://catwitch.eu/jplop/post',
               cookie_url: 'http://catwitch.eu/jplop/logon',
               cookie_name: '[JSESSIONID]',
               remember_me_parameter: '',
               user_parameter: 'username',
               pwd_parameter: 'password'
)

Tribune.create(name: 'finss',
               refresh_interval: 120,
               get_url: 'http://finss.free.fr/drupal/?q=tribune.xml',
               last_id_parameter: 'last_id',
               post_parameter: 'message',
               post_url: 'http://finss.free.fr/drupal/?q=tribune/post',
               cookie_url: 'http://finss.free.fr/drupal/?q=tribune',
               cookie_name: '[SESS.*]',
               remember_me_parameter: 'persistent_login',
               user_parameter: 'name',
               pwd_parameter: 'pass'
)
# TODO: voir pourquoi ça marche pas
#Tribune.create(name: 'olo',
#               refresh_interval: 120,
#               get_url: 'http://board.olivierl.org/remote.xml',
#               last_id_parameter: '',
#               post_parameter: 'message',
#               post_url: 'http://board.olivierl.org/add.php',
#               cookie_url: 'http://board.olivierl.org/user/login.php',
#               cookie_name: '[unique_id]',
#               remember_me_parameter: '',
#               user_parameter: 'login',
#               pwd_parameter: 'passwd'
#)

Tribune.create(name: 'ratatouille',
               refresh_interval: 120,
               get_url: 'http://ratatouille.leguyader.eu:80//data/backend.xml',
               last_id_parameter: '',
               post_parameter: 'message',
               post_url: 'http://ratatouille.leguyader.eu:80//add.php',
               cookie_url: 'http://ratatouille.leguyader.eu:80/loginA.php',
               cookie_name: '[faab_id]',
               remember_me_parameter: '',
               user_parameter: 'login',
               pwd_parameter: 'password'
)

Tribune.create(name: 'gabuzomeu',
               refresh_interval: 120,
               get_url: 'http://gabuzomeu.fr/tribune.xml',
               last_id_parameter: '',
               post_parameter: 'message',
               post_url: 'http://gabuzomeu.fr/tribune/post',
               cookie_url: '',
               cookie_name: '',
               remember_me_parameter: '',
               user_parameter: '',
               pwd_parameter: ''
)

#Tribune.create(name: 'kadreg',
#               refresh_interval: 120,
#               get_url: 'http://kadreg.org/board/backend.php',
#               last_id_parameter: '',
#               post_parameter: 'message',
#               post_url: 'http://kadreg.org/board/add.php',
#               cookie_url: '',
#               cookie_name: '',
#               remember_me_parameter: '',
#               user_parameter: '',
#               pwd_parameter: ''
#)

Tribune.create(name: 'hadoken',
               refresh_interval: 120,
               get_url: 'http://hadoken.free.fr/board/remote.php',
               last_id_parameter: '',
               post_parameter: 'message',
               post_url: 'http://hadoken.free.fr/board/post.php',
               cookie_url: '',
               cookie_name: '',
               remember_me_parameter: '',
               user_parameter: '',
               pwd_parameter: ''
)

#Tribune.create(name: 'comptoir',
#               refresh_interval: 120,
#               get_url: 'http://lordoric.free.fr/daBoard/remote.xml',
#               last_id_parameter: '',
#               post_parameter: 'message',
#               post_url: 'http://lordoric.free.fr/daBoard/remote.xml',
#               cookie_url: '',
#               cookie_name: '',
#               remember_me_parameter: '',
#               user_parameter: '',
#               pwd_parameter: ''
#
#)

Tribune.create(name: 'darkside',
               refresh_interval: 120,
               get_url: 'http://quadaemon.free.fr/remote.xml',
               last_id_parameter: '',
               post_parameter: 'message',
               post_url: 'http://quadaemon.free.fr/add.xml',
               cookie_url: '',
               cookie_name: '',
               remember_me_parameter: '',
               user_parameter: '',
               pwd_parameter: ''

)

Tribune.create(name: 'ygllo',
               refresh_interval: 120,
               get_url: 'http://ygllo.com/tribune.xml',
               last_id_parameter: '',
               post_parameter: 'message',
               post_url: 'http://ygllo.com/tribune/post',
               cookie_url: '',
               cookie_name: '',
               remember_me_parameter: '',
               user_parameter: '',
               pwd_parameter: ''
)


Tribune.create(name: 'djangotribune-demo',
               refresh_interval: 120,
               get_url: 'http://sveetchies.sveetch.net/tribune/remote/xml/',
               last_id_parameter: 'last_id',
               post_parameter: 'content',
               post_url: 'http://sveetchies.sveetch.net/tribune/post/xml/',
               cookie_url: '',
               cookie_name: '',
               remember_me_parameter: '',
               user_parameter: '',
               pwd_parameter: ''
)