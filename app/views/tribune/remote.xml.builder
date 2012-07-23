# Non utilisé à cause d'un problème de sortie et d'espaces en plus

xml.board :site => "truc", :timezone => "DTC" do
  @results.each do |p|
    xml.post :time => p.time, :id => p.id do
      xml.info p.info
      xml.login p.login
      xml.message {
        xml << p.message
      }
    end
  end
end
