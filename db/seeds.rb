# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Tribune.create(name: 'shoop',
               get_url: "http://dax.sveetch.net/tribune/remote.xml",
               last_id_parameter: "last",
               post_parameter: "content",
               post_url: "http://dax.sveetch.net/tribune/post.xml",
               cookie_url: "http://dax.sveetch.net/accounts/login/",
               cookie_name: %w(shoop_sessionid),
               user_parameter: "username",
               pwd_parameter: "password")

Tribune.create(name: 'euro',
               get_url: "http://euromussels.eu/?q=tribune.xml",
               last_id_parameter: "last_id",
               post_parameter: "message",
               post_url: "http://euromussels.eu/?q=tribune/post",
               cookie_url: "http://euromussels.eu/tribune",
               cookie_name: %w(SESS.*),
               user_parameter: "name",
               pwd_parameter: "pass")
