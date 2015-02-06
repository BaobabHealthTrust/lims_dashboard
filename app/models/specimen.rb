class Specimen
 def get_specimens_with_location(location)
  setting = Settings.new()
  url = "http://#{setting.get_setting('ip_address')}/#{setting.get_setting('folder')}/htdocs/api/get_specimen_details.php"
  puts url
  data = JSON.parse(RestClient.post(url, {:start_date => Date.today, :department => location})) rescue (
  puts "**** Error when pulling data"
  )
 end

 def get_specimens()
  setting = Settings.new()
  url = "http://#{setting.get_setting('ip_address')}/#{setting.get_setting('folder')}/htdocs/api/get_specimen_details.php"
  puts url
  data = JSON.parse(RestClient.post(url, {:start_date => Date.today})) rescue (
  puts "**** Error when pulling data"
  )
 end
end
