# encoding: utf-8

module OlccsPlugins
  class Google
    include Singleton

    def process(search)
      "https://www.google.com/search?q=#{CGI.escape(search)}"
    end

  end
end