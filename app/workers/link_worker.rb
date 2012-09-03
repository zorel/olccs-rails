class LinkWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false, :queue => :link

  def perform(link_id)

    link = Link.find(link_id)
    puts ("Sidekiq job for #{link.inspect}")
    link.index
  end
end