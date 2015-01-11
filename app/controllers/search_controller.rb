class SearchController < ApplicationController
  def jobs
    @per_page = params[:per_page] ? params[:per_page] : 10
    @jobs = Job.search(params[:target]).paginate(page: params[:page], per_page: @per_page).order(:id)
    @hash = get_map_hash
  end

  def volunteers
    @per_page = params[:per_page] ? params[:per_page] : 10
    @volunteers = User.search(params[:target]).paginate(page: params[:page], per_page: @per_page).order(:id)
  end

  def posters
    @per_page = params[:per_page] ? params[:per_page] : 10
    @posts = Post.search(params[:target]).paginate(page: params[:page], per_page: @per_page).order(:id)
  end

  private
  def get_map_hash
    Gmaps4rails.build_markers(@jobs) do |job, marker|
      marker.json({id: job.id})
      marker.lat job.lat
      marker.lng job.lng
      marker.infowindow %(#{job.title}<br>地址： #{job.location})
    end
  end
end
