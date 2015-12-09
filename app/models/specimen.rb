class Specimen
 def get_specimens_with_location(location, type)
  setting = Settings.new()
  url = "http://#{setting.get_setting('username')}:#{setting.get_setting('password')}@#{setting.get_setting('ip_address')}:#{setting.get_setting('port')}/api/dashboard_stats?"
  url= url + "test_status=pending,started,completed&specimen_status=specimen-accepted&department=#{location}"

  data = JSON.parse(RestClient.get(url))
 end

 def get_specimens(department,status=nil,location = nil)
  setting = Settings.new()
  url = "http://#{setting.get_setting('username')}:#{setting.get_setting('password')}@#{setting.get_setting('ip_address')}:#{setting.get_setting('port')}/api/dashboard_stats?"
  params = {:date => DateTime.now.to_s(:db), :dashboard_type => department}
  params[:status] = status if !status.blank?
  params[:ward] = location if !location.blank?

  data = JSON.parse(RestClient.get(url, params))
 end
end
