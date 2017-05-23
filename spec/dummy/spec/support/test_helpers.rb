def restore_default_config
  Planter.configuration = nil
  Planter.configure {}
end
