class DashboardController < ApplicationController

  def lab_department
    data = {
        :data => Dashboard.get_data((params[:department].downcase.split(",") rescue []), (params[:ward].downcase.split(",") rescue [])),
        :stats => Dashboard.get_stats((params[:department].downcase.split(",") rescue []), (params[:ward].downcase.split(",") rescue [])),
        :time => "#{DateTime.now.strftime("%d %b, %Y %H:%M")}"
    }

    render :text => data.to_json
  end

end
