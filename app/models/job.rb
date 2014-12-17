class Job < ActiveRecord::Base
  validates :title, presence: true
  validates :joburl, presence: true

  geocoded_by :location,
    latitude: :lat, longitude: :lng
  after_validation :geocode

  scope :search, ->(target) { where("title like ? or content like ? or location like ?",
                                    "%#{target}%", "%#{target}%", "%#{target}%") }
end
