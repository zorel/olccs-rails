require "fnordmetric"

FnordMetric.namespace :olccs do
  toplist_gauge :popular_tribunes, title: "Popular tribunes"


  event :tribune_index do
    observe :popular_tribunes, data[:name]

  end
end

FnordMetric.standalone
