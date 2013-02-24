TorqueBox.configure do
  environment do
    RAILS_ENV 'production'
  end
    
  queue '/queue/r_queue' do
    processor RefreshProcessor do
      concurrency 4
    end
    durable false
  end

  job RefreshJob do
    cron '*/10 * * * * ?'
    timeout '10s'
  end

end
