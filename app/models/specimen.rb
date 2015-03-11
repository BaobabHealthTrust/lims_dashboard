class Specimen
 def get_specimens_with_location(location, type)
  setting = Settings.new()
  url = "http://#{setting.get_setting('username')}:#{setting.get_setting('password')}@#{setting.get_setting('ip_address')}:#{setting.get_setting('port')}/#{setting.get_setting('folder')}/htdocs/api/get_specimen_details.php"
  params = {:date => Date.today, :department => "'" + location + "'" , :dashboard_type => type, :status=> "'Received At Reception','Received In Department'" }
  data = JSON.parse(RestClient.post(url, params)) rescue (
  puts "**** Error when pulling data"
  )
 end

 def get_specimens(department,status=nil,location = nil)
  setting = Settings.new()
  url = "http://#{setting.get_setting('username')}:#{setting.get_setting('password')}@#{setting.get_setting('ip_address')}:#{setting.get_setting('port')}/#{setting.get_setting('folder')}/htdocs/api/get_specimen_details.php"
  params = {:date => Date.today, :dashboard_type => department}
  params[:status] = status if !status.blank?
  params[:ward] = location if !location.blank?
  data = JSON.parse(RestClient.post(url, params)) rescue (
  puts "**** Error when pulling data"
  )
 end
end
