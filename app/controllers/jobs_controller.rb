class JobsController < ApplicationController

  def index
    @per_page = params[:format] ? params[:format] : 10
    @page = params[:page]
    @jobs = Job.paginator(@page, @per_page)
    @hash = get_map_hash
  end

  def show
    @job = Job.find(params[:id])
  end

  def search
    @per_page = params[:format] ? params[:format] : 10
    @jobs = Job.search(params[:target]).paginate(page: params[:page], per_page: @per_page).order(:id)
    @hash = get_map_hash
    render :index
  end

  def distance
    @per_page = params[:format] ? params[:format] : 10
    @location = params[:location]
    @page = params[:page]
    @jobs = Job.distance_from(@location).paginator(@page, @per_page)
    @hash = get_map_hash
    render :index
  end

  private
  def get_map_hash
    Gmaps4rails.build_markers(@jobs) do |job, marker|
      marker.lat job.lat
      marker.lng job.lng
      marker.infowindow %(##{job.id} #{job.title}<br>地址： #{job.location})
    end
  end
end
