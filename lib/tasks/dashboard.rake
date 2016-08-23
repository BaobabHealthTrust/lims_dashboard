namespace :dashboard do
  desc "TODO"
  task time_broadcast: :environment do
    WebsocketRails[:time_sync].trigger :server_datetime, "#{DateTime.now.strftime("%d %b, %Y %H:%M")}"
  end

  task data_broadcast: :environment do
    WebsocketRails[:lab_department].trigger :lab_department, Dashboard.get_data.to_json
  end

end
