TorqueBox.configure do
  environment do
    RAILS_ENV 'production'
  end
    
  queue '/queue/r_queue' do
    processor RefreshProcessor
    durable false
  end

  job RefreshJob do
    cron '*/5 * * * * ?'
    timeout '10s'
  end

end
