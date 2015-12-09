class Specimen
 def get_specimens_with_location(location, type)
  setting = Settings.new()
  url = "http://#{setting.get_setting('username')}:#{setting.get_setting('password')}@#{setting.get_setting('ip_address')}:#{setting.get_setting('port')}/api/dashboard_stats?"
  url= url + "test_status=pending,started,completed&specimen_status=specimen-accepted&department=#{location}"

  data = JSON.parse(RestClient.get(url))
 end

 def get_specimens(status=nil)
  setting = Settings.new()
  url = "http://#{setting.get_setting('username')}:#{setting.get_setting('password')}@#{setting.get_setting('ip_address')}:#{setting.get_setting('port')}/api/dashboard_stats?"
  url= url + "test_status=pending,not-received&specimen_status=specimen-not-collected"

  data = JSON.parse(RestClient.get(url))
 end
end
