class HomeController < ApplicationController
 def index
 end

 def registration_dashboard
  @specimens = []
  @ordered = 40
  @received = rand(20)
  @tested = rand(40)
  @pending = rand(@received).to_i
  @turn_around = (rand() * 10).round(1)

 end

 def lab_dashboard
 end

 def nurse_dashboard
 end

 def ajax_lab_reception_list
  @specimens = []
  @ordered = 20
  @received = rand(20)
  render :text => view_context.lab_registration(params[:location]).to_json
 end

 def ajax_lab_dashboard_list
  @specimens = []
  list = Specimen.new().get_specimens(params[:location])
  render :text => view_context.lab_dashboard(list).to_json
 end

 def ajax_nurse_dashboard_list
  @specimens = []
  render :text => view_context.nurse_dashboard(params[:location]).to_json
 end
end
