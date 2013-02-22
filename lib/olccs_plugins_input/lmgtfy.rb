# encoding: utf-8

module OlccsPlugins
  class Lmgtfy
    include Singleton

    def initialize
      @tiny_api = 'https://tinyurl.com/api-create.php?url=http://lmgtfy.com/?q=#placeholder#'

    end

    def process(search)
      client = HTTPClient.new
      response = client.get(@tiny_api.sub('#placeholder#',CGI.escape(search)))
      response.content
    end

  end
end