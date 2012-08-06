class RefreshWorker
  include Sidekiq::Worker

  def perform(tribune_id)
    tribune = Tribune.find(tribune_id)

    now = Time.now
    to_be = (now - last_updated) > refresh_interval
    if to_be
      tribune.refresh
      tribune.update_attributes last_updated: now
      logger.info "Reload fini pour board #{name}"
    else
      logger.info "Pas de reload pour board #{name}"
    end
    to_be
  end
end