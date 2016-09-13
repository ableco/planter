$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'planter'

def restore_default_config
  Planter.configuration = nil
  Planter.configure {}
end
