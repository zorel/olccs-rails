require_relative '../config/boot'
require_relative '../config/environment'
require 'clockwork'
include Clockwork

every(10.second, 'tribune.refresh') { Tribune.refresh_all }
