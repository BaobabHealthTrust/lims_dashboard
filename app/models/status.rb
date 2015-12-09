class Status
def get_status(type, ward, dept)
 setting = Settings.new()
 params = {:dashboard_type =>  type, :ward => ward,  :department => dept, :date => DateTime.now.to_s(:db)}
 url = "http://#{setting.get_setting('username')}:#{setting.get_setting('password')}@#{setting.get_setting('ip_address')}:#{setting.get_setting('port')}/api/dashboard_aggregates?"
 url = url + "department=#{dept}&ward=#{ward}"
 data = JSON.parse(RestClient.get(url))
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
