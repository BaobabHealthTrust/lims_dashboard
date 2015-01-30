class Specimen
 def get_specimens(location)
  setting = Settings.new()
  url = "http://#{setting.get_setting('ip_address')}/MalawiBLIS/htdocs/api/get_specimen_details.php"
  puts url
  data = JSON.parse(RestClient.post(url, {:start_date => Date.today, :department => location})) rescue (
  puts "**** Error when pulling data"
  )
 end
end
