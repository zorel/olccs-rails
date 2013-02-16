if defined?(TorqueBox::Messaging::Backgroundable) && defined?(ActiveRecord::Base)
  ActiveRecord::Base.send(:include, TorqueBox::Messaging::Backgroundable)
end
