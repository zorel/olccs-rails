require 'strscan'
require 'singleton'

# Principe gÃ©nÃ©ral: on avance dans la chaine via un StringScanner (cf http://ruby-doc.org/core/classes/StringScanner.html ), et en fonction de ce qu'on rencontre, on effectue un traitement.

class Slip
  include Singleton

  #AUTHORIZED_SCHEMES_ARRAY = ["http", "https", "ftp", "ftps"]
  #AUTHORIZED_TAGS_ARRAY = ["b", "i", "m", "s", "tt", "u"]
  #OPEN_TAGS_ARRAY = AUTHORIZED_TAGS_ARRAY.collect {|t| "<#{t}>"}
  #CLOSE_TAGS_ARRAY = AUTHORIZED_TAGS_ARRAY.collect {|t| "</#{t}>"}
  #TAGS_ARRAY = (OPEN_TAGS_ARRAY+CLOSE_TAGS_ARRAY).flatten
  #
  #OPEN_TAGS = "(" + OPEN_TAGS_ARRAY.join("|") + ")"
  #CLOSE_TAGS = "(" + CLOSE_TAGS_ARRAY.join("|") + ")"
  CLOCK = "(2[0-3]|[01][0-9])(?:(?:(?:\:([0-5][0-9])\:([0-5][0-9])|([0-5][0-9])([0-5][0-9]))(?:[\:\^]([0-9]{1,2})|([Â¹Â²Â³]))?)|\:([0-5][0-9]))(@[-_\.a-z]+)?"
  SMILEY = "\\\[:([0-9a-zA-Z \*\$@'_-]+)\\\]"
  LESSON = "[lL]eçon ([0-9]{1,3}(?: bis)?)"
  CLOCK_REGEXP = Regexp.new(CLOCK)
  #URI = "(#{AUTHORIZED_SCHEMES_ARRAY.join("|")})://"

  RE = Regexp.new("(#{SMILEY}|#{LESSON}|#{CLOCK}|\\s|$)")

  URL_SUBSTITUTION = {
      "http://localhost" => "[localhost]",
      "wiki\\.logicielslibres\\.info" => "[wiki.llfr.info]",
      "wikipedia\\.org/wiki/(.*)" => "[\\1@wikipedia]",
      "logicielslibres\\.info" => "[llfr.info]",
      "fnac\\.com" => "[fnac]",
      "google\\." => "[google]",
      "yahoo\\." => "[yahoo]",
      "lemonde\\.fr" => "[lemonde]",
      "liberation\\.fr" => "[libe]",
      "lefigaro\\.fr" => "[lefigaro]",
      "journaldunet\\." => "[jdn]",
      "01net\\.com" => "[01net]",
      "forum\\.hardware" => "[hfr]",
      "linuxfr\\.org" => "[beyrouth]",
      "goatse" => "[pas cliquer!]",
      ".ssz.fr" => "[pas cliquer non plus!]",
      "goat\\.cx" => "[pas cliquer!]",
      "minilien" => "[minilien]",
      "britney" => "[britney]",
      "wiki" => "[wiki]",
      "wickedweasel" => "[WW]",
      "teen" => "[ducul]",
      "horse" => "[ducheval]",
      "stileproject\\.com" => "[stileproject]",
      "slashdot\\.org" => "[/.]",
      "kde" => "[kde]",
      "gnome" => "[gnome]",
      "somethingawful\\.com" => "[SA]",
      "osnews\\.com" => "[osnews]",
      "zdnet\\." => "[zdnet]",
      "kuro5hin\\.org" => "[K5]",
      "freshmeat\\." => "[FM]",
      "securityfocus\\.com" => "[securityfocus]",
      "debian" => "[debian]",
      "mandrake" => "[mdk]",
      "redhat" => "[rh]",
      "rpmfind" => "[rpmfind]",
      "gentoo" => "[gentoo]",
      "microsoft" => "[MS]",
      "wmcoincoin" => "[wmcc]",
      "pycoincoin" => "[pycc]",
      "voltairenet\\.org" => "[conspiration]",
      "ruby" => "[ruby]",
      "/goomi/unspeakable" => "[Fhtagn!]",
      "youtube\\.com" => "[youtube]",
      "dailymotion\\.com" => "[dailymotion]",
      "bashfr\\.org" => "[bashfr]",
      "imdb\\.com" => "[imdb]",
      "http://(.*)\\.free\\.fr" => "[\\1@free]",
      "\\.(jpe?g|png|gif)$" => "[\\1]",
      "\\.swf" => "[flash]",
      "\\.tar\\.gz" => "[tgz]",
      "\\.tgz" => "[tgz]",
      "\\.(rpm|deb|tgz)$" => "[\\1]",
      "\\.deb" => "[deb]",
      "\\.mp3" => "[mp3]",
      "\\.ogg" => "[ogg]",
      "\\.pdf" => "[pdf]",
      "ftp:/" => "[ftp]",
      "dtc" => "[dtc]",
      "dyndns\\.org" => "[dyndns]"
  }

  # Appelle le slip, avec en paramÃ¨tre la chaine a slipper et un plugin Ã©ventuel en paramÃ¨tre
  def slip(chaine, asked_filter="")
    # str est le string scanner sur la chaine sans espace double et sans espace avant/aprÃ¨s
    str = StringScanner.new(chaine.strip.squeeze(" "))
    # found contient la chaine matchÃ© si on en a trouvÃ© une
    # tags contient la liste des tags rencontrÃ©s, afin de les terminer correctement
    # urls la liste des urls trouvÃ©es
    # slipped et slipped_for_remote les chaines slippÃ©es
    found = ""
    tags = Array.new
    urls = Array.new
    horloges = Array.new
    slipped = ""
    slipped_for_remote = ""
    # tant qu'on est pas Ã  la fin du string scanner
    while !str.eos?
      # on tente de trouver un pattern correspondant Ã  l'endroit oÃ¹ est le point
      r = str.scan(RE)
      # on a trouvÃ© un pattern contenu dans RE, donc r contient la chaine correspondante et before est nul
      if r!=nil
        found = r
        before = nil
      else
        # sinon, on scanne jusqu'Ã  ce qu'on trouve un pattern, et before contiendra la chaine qui n'a pas matchÃ©
        # found contiendra la chaine matchÃ©e
        str.scan_until(RE)
        found = str.matched
        before = str.pre_match
      end
      # si before existe, c'est une chaine "normale"
      if !before.nil?
        # donc on applique le filtre Ã©ventuel (si filter est vide, on retourne la chaine telle quelle)
        if filters
          text = xmlentities(apply_filters(before, asked_filter))
        else
          text = xmlentities(before)
        end
        # on remplit les slips
        slipped << text
        slipped_for_remote << text
      end
      # on commence le traitement de ce qu'on a trouvÃ©
      # si c'est un espace
      if found == " "
        slipped << found
        slipped_for_remote << found
      elsif found.match(SMILEY)
        # si c'est un smiley
        #        smiley = "<a class=\"smiley snap_nopreview\" href=\"http://forum-images.hardware.fr/images/perso/#{str[2]}.gif\">[:#{str[2]}]</a>"
        smiley = "<a class=\"smiley snap_nopreview\" href=\"http://totoz.eu/#{str[2]}.gif\">[:#{str[2]}]</a>"
        slipped << smiley
        slipped_for_remote << smiley
      elsif found.match(LESSON)
        # si c'est une leÃ§on
        lesson = "<a href=\"http://wiki.logicielslibres.info/wiki/published/Le%C3%A7on%20#{str[3]}\">#{str[0]}</a>"
        slipped << lesson
        slipped_for_remote << lesson
      elsif found.match(OPEN_TAGS)
        # si c'est un tags, on mets le tag dans le tableau tags
        tags << found[1..-1]
        #traitement du <m> en moment
        if (found=="<m>")
          slipped << "====&gt; <b>Moment "
          slipped_for_remote << "====&gt; <b>Moment "
        else
          slipped << found
          slipped_for_remote << found
        end
      elsif found.match(CLOSE_TAGS)
        # si c'est un tag fermant
        found_tag = found[2..-1]
        # Si le tag fermant correspond au dernier tag mis dans tags, alors c'est bon, c'est bien balancÃ©, on vire le tag du tableau et on remplit les slips
        if (found_tag == tags.last)
          tags.pop
          slipped << close_tag(found_tag)
          slipped_for_remote << close_tag(found_tag)
        else
          #sinon, on recherche le tag Ã©quivalent dans le tableau, en partant de la fin
          last_index = tags.rindex(found_tag)
          if (!last_index.nil?)
            #trouvÃ©, on recule dans le tableau et on clos les tags un Ã  un en les supprimant
            (tags.length-1).downto(last_index) do |index|
              tag_to_close = tags.pop
              slipped << close_tag(tag_to_close)
              slipped_for_remote << close_tag(tag_to_close)
            end
          else
            # pas trouvÃ©, on mets le tag tel quel en xmlentities pour l'afficher
            slipped << xmlentities(found)
            slipped_for_remote << xmlentities(found)
          end
        end
      elsif found.match(CLOCK)
        # si c'est une horloge
        # on slit l'horloge selon la regexp
        # cross tribune savoir si l'horloge est de la forme hh:mm:ss@tribune
        # tribune pour contenir le nom de la tribune
        splitted = found.split(CLOCK_REGEXP)
        cross_tribune = false
        tribune = ""
        norloge = found
        # on prends chaque Ã©lÃ©ment du slip de l'horloge, on remplace les Â¹ et cie par 01... et on aligne sur 2 cars
        splitted.shift
        splitted << "01" if splitted.size==3
        splitted.collect! do |elt|
          if elt =='Â¹'
            elt = '01'
          elsif elt == 'Â²'
            elt = '02'
          elsif elt == 'Â³'
            elt = '03'
          elsif elt[0..0] == "@"
            cross_tribune = true
            elt = elt[1..-1]
            tribune = elt
          else
            elt = elt.rjust(2,"0")
          end
          elt
        end

        # si on est dans du cross tribune
        if cross_tribune == true
          # On ne fait rien pour le slip http
          splitted.pop
          # Mettre ici le code pour gÃ©rer les cross tribioune en mode web
          slipped << "#{norloge}"
          slipped_for_remote << "<clock time=\"#{splitted.join}\" board=\"#{tribune}\">#{norloge}</clock>"
        else
          slipped << "<span class=\"horloge_ref\">#{norloge}</span>"
          slipped_for_remote << "<clock time=\"#{splitted.join}\">#{norloge}</clock>"
          # p splitted
          horloges << splitted.join
        end
      elsif found.match(URI)
        # On a trouvÃ© une url
        # t contient le caractÃ¨re avant l'url, pour savoir si l'url est entourÃ©e par des () ou []
        t = str.pre_match[-1,1]
        # on positionne le caractÃ¨re de fin correspondant
        case t
          when "("
            e = "\\)"
          when "["
            e = "\\]"
          when ">"
            e = "<"
          else
            e = ""
        end
        # terminator contient, en fonction de s'il y a un (/[ ou pas, la regex de fin.
        # en gros, on continue de lire jusqu'Ã  ce qu'on tombe sur )/] (au cas oÃ¹), une espace ou un tag
        terminator = (!t.nil? and e != "") ? "(#{e}|\\s|#{TAGS_ARRAY.join('|')}|$)" : "(\\s|#{TAGS_ARRAY.join('|')}|$)"
        # On scanne la chaine jusqu'Ã  temps qu'on tombe sur un terminateur
        t = str.scan_until(Regexp.new(terminator))
        # gros nack pour rÃ©injecter dans le slip le terminateur. Utile, parceque si on tombe sur un tag, il faut le repasser par le code OPEN/CLOSE tag plus haut
        # alors on repositionne le pointeur du scanner sur la fin de l'url (en fonction de la taille du terminateur
        str.pos = str.pos - str.matched.length
        found = found+t[0,t.length-str.matched.length]
        link = "<a href=\"#{found}\">#{xmlentities(url_replace(found))}</a>"
        slipped << link
        slipped_for_remote << link
        urls << found
      end
      # fin des if, la chaine du scanner contiendra pour le prochain tour la fin (aprÃ¨s le point repositionnÃ© Ã©ventuellement par found URI.
      str.string = str.rest
    end
    # s'il reste des tags, on les ferme
    tags.each do |tag|
      slipped << close_tag(tag)
      slipped_for_remote << close_tag(tag)
    end
    return slipped, slipped_for_remote, chaine, urls, horloges
  end

  def xmlentities(string)
    return string.gsub(/&/, '&amp;').gsub(/"/,'&quot;').gsub(/</,'&lt;').gsub(/>/,'&gt;')
  end

  # Remplacement des URL pour faire beau
  def url_replace(url)
    URL_SUBSTITUTION.each do |pattern, replacement|
      if url.match(pattern)
        return url.gsub(Regexp.new(".*#{pattern}.*","uxim"), replacement)
      end
    end
    return "[url]"
  end

  # Fermeture des tags
  def close_tag(tag)
    if (tag == "m>")
      return "</b> &lt;===="
    else
      return "</#{tag}"
    end
  end

  # On applique le filtre
  def apply_filters(chaine, asked_filter= "")
    # m contient la classe du filtre, donc pour le filtre machin, on recherche :machin_slip dans le hash
    m = filters["#{asked_filter}_slip".to_sym]
    # Si m existe, on appelle m.instance (classe singleton), et on applique
    chaine = m.nil? ? chaine : m.instance.filter(chaine)
    return chaine
  end
end

# SystÃ¨me de plugin, c'est beau, j'en pleurerais
# f contient le hash :machin_slip => MachinSlip
f = Hash.new
# On lit chaque fichier *_slip.rb dans le rÃ©pertoire de slip.rb
Dir["#{File.dirname(__FILE__)}/*_slip.rb"].sort.each do |filter_name|
  # On fait un require sur le fichier
  require filter_name
  # Le nom de la classe doit correspondre au nom du fichier:
  # filtre machin, classe MachinSlip, fichier machin_slip.rb
  klass = File.basename(filter_name).sub(/\.rb/, '')
  # LÃ  c'est beau
  # "machin_slip".to_sym => :machin_slip, c'est ce symbole qu'on mets dans le hash
  # "machin_slip".classify => MachinSlip, const_get pour chercher la classe de nom MachinSlip dans le module SlipPlugin
  # la "valeur" pour la clÃ© :machin_slip sera donc un objet de type Class
  f[klass.to_sym] = SlipPlugin.const_get(klass.classify)
end
# on mets les filtres dans l'instance unique du slip
Slip.instance.filters = f

