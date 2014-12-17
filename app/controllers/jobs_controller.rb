class JobsController < ApplicationController

  def index
    @per_page = params[:format] ? params[:format] : 10
    @jobs = Job.paginate(page: params[:page], per_page: @per_page).order(:id)
    @hash = Gmaps4rails.build_markers(@jobs) do |job, marker|
      marker.lat job.lat
      marker.lng job.lng
    end
  end

  def show
    @job = Job.find(params[:id])
  end

end
