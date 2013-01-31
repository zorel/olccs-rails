class RefreshProcessor < TorqueBox::Messaging::MessageProcessor
  def on_message(body)
    @logger = TorqueBox::Logger.new( self.class )
    @logger.info('  RefreshProcessor received refresh for tribune id: ' + body.to_s)
    Tribune.find(body).refresh
  end
end