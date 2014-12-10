class JobsController < ApplicationController

  def index
    @jobs = Job.all
    @hash = Gmaps4rails.build_markers(@jobs) do |job, marker|
      marker.lat job.lat
      marker.lng job.lng
    end
  end

end
