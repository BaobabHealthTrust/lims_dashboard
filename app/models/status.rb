class Status
def get_status(type, location)
 setting = Settings.new()
 params = {:dashboard_type =>  type, :location => location, :date => DateTime.now.to_s(:db)}
 url = "http://#{setting.get_setting('username')}:#{setting.get_setting('password')}@#{setting.get_setting('ip_address')}:#{setting.get_setting('port')}/#{setting.get_setting('folder')}/htdocs/api/get_dashboard_stats.php"
 puts url
 data = JSON.parse(RestClient.post(url, params)) rescue (
 puts "**** Error when pulling data"
 )
end

def get_lab_status
 setting = Settings.new()
 url = "http://#{setting.get_setting('username')}:#{setting.get_setting('password')}@#{setting.get_setting('ip_address')}:#{setting.get_setting('port')}/#{setting.get_setting('folder')}/htdocs/api/get_lab_status.php"
 puts url
 data = JSON.parse(RestClient.post(url, {:date => DateTime.now.to_s(:db)})) rescue (
 puts "**** Error when pulling data"
 )

end
end
