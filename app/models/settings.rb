class Settings
 $blis_settings = YAML.load_file("#{Rails.root}/config/application.yml")["bliss_connection"]

 def get_setting(setting)
  return $blis_settings[setting] rescue ""
 end
end