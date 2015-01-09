class JobsController < ApplicationController

  def index
    @per_page = params[:per_page] ? params[:per_page] : 10
    @page = params[:page]
    if @location = params[:location]
      distance
    elsif @target = params[:target]
      search
    else
      @jobs = Job.paginator_recent(@page, @per_page)
      @hash = get_map_hash
    end
  end

  def show
    @job = Job.find(params[:id])
  end

  def search
    @per_page = params[:per_page] ? params[:per_page] : 10
    @jobs = Job.search(params[:target]).paginate(page: params[:page], per_page: @per_page).order(:id)
    @hash = get_map_hash
    render :index
  end

  def distance
    @per_page = params[:per_page] ? params[:per_page] : 10
    @location = params[:location]
    @page = params[:page]
    @jobs = Job.distance_from(@location).paginator(@page, @per_page)
    @hash = get_map_hash
    render :index
  end

  private
  def get_map_hash
    Gmaps4rails.build_markers(@jobs) do |job, marker|
      marker.json({id: job.id})
      marker.lat job.lat
      marker.lng job.lng
      marker.infowindow %(##{job.id} #{job.title}<br>地址： #{job.location})
    end
  end
end
