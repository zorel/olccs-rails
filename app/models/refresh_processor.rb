class RefreshProcessor < TorqueBox::Messaging::MessageProcessor
  def on_message(body)
    logger.info('  RefreshProcessor received: ' + body.to_s)
  end
end