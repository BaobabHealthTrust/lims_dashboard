class HomeController < ApplicationController

  def index

    @department = params[:department].titleize rescue nil

    @time = "#{DateTime.now.strftime("%d %b, %Y %H:%M")}"

  end
end
