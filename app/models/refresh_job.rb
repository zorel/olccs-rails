class RefreshJob

  def initialize
    @logger = TorqueBox::Logger.new( self.class )
    @logger.info(' RefreshJob : init')
  end

  def run
    @logger.info(' RefreshJob : run')
    Tribune.refresh_all
    @logger.info(' RefreshJob : done')
  end

  def on_timeout
    @logger.error 'Refresh timeout, you\'re fucked'
  end
end