Tire.configure do
  url Figaro.env.es_host
  wrapper Hash
  #logger 'elasticsearch.log', :level => 'debug'
end
