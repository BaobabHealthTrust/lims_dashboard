class HomeController < ApplicationController
 def index
 end

 def registration_dashboard
  status = Status.new().get_status('lab_reception','', params[:location])
  @ordered = status['ordered']
  @received = status['received']
  @testing = status['started']
  @tested = status['completed']
  @pending = status['pending']
  @turn_around = "-" #(status["avg_tat_in_min"].blank? ? 0 : status["avg_tat_in_min"]).to_s + " mins"

 end

 def lab_dashboard
 end

 def nurse_dashboard
 end

 def waiting_room_dashboard

 end

 def ajax_lab_reception_list

  list = Specimen.new().get_specimens('pending')
  result = view_context.lab_registration(list).to_json
  render :text => result
 end

 def ajax_lab_dashboard_list

  list = Specimen.new().get_specimens_with_location(params[:location], 'labdepartment')
  render :text => view_context.lab_dashboard(list).to_json
 end

 def ajax_nurse_dashboard_list

  list = Specimen.new().get_specimens("'Ordered','Drawn','Test Rejected', 'Sample Rejected', 'Result Rejected', 'Verified','Tested'")
  render :text => view_context.nurse_dashboard(list).to_json
 end

 def ajax_waiting_room_dashboard
  status = Status.new().get_lab_status
  render :text => view_context.waiting_room(status).to_json
 end

 def ajax_lab_reception_stats
  status = Status.new().get_status(params[:type], params[:ward], params[:location])
  render :text => status.to_json
 end

 def time
  render :text => Time.now().strftime('%Y-%m-%d %H:%M').to_s
 end
end
