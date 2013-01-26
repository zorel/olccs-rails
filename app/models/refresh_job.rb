class RefreshJob

  def initialize
    @logger = TorqueBox::Logger.new( self.class )
    @logger.info(' RefreshJob :start')
  end

  def run
    @logger.info(' RefreshJob :run')
    Tribune.refresh_all
  end
end