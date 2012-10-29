class RefreshWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false, :queue => :tribune

  def perform(tribune_id)
    tribune = Tribune.find(tribune_id)

    now = Time.now
    to_be = (now - tribune.last_updated) > tribune.refresh_interval
    if to_be
#      tribune.with_lock do
        tribune.refresh
#      end
#      tribune.logger.info "Reload fini pour board #{tribune.name}"
    else
#      tribune.logger.info "Pas de reload pour board #{tribune.name}"
    end
    to_be
  end
end
