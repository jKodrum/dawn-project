class Job < ActiveRecord::Base
  validates :title, presence: true
  validates :joburl, presence: true

  geocoded_by :location,
    latitude: :lat, longitude: :lng
  after_validation :geocode

  scope :search, ->(target) { where("title like ? or content like ? or location like ?",
                                    "%#{target}%", "%#{target}%", "%#{target}%") }
  scope :distance_from, ->(location) { near(location, 10, {unit: :km}).order("distance") }
  scope :paginator, ->(page, per_page) { paginate(page: page, per_page: per_page).order(:id) }
  scope :paginator_recent, ->(page, per_page) { paginate(page: page, per_page: per_page).order(last_modified: :desc) }
end
