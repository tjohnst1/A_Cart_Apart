class FoodCart < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search, against: [:name, :address],
                           using: { tsearch: { prefix: true, dictionary: "english" }},
                           ignoring: [:accents],
                           associated_against: { tags: :name }

  geocoded_by :portland_address
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }

  has_many :reviews
  acts_as_taggable

  validates :name, presence: true
  validates :address, presence: true

  def average_review
    if self.reviews.length > 0
      reviewTotal = 0
      self.reviews.each do |review|
        reviewTotal += review.rating.to_f
      end
      (reviewTotal / self.reviews.length).round
    else
      "No Reviews"
    end
  end

  private
  def default_values
    self.phone_number ||= "Not Provided"
    self.website ||= "Not Provided"
    self.monday_hours ||= "Closed"
    self.tuesday_hours ||= "Closed"
    self.wednesday_hours ||= "Closed"
    self.thursday_hours ||= "Closed"
    self.friday_hours ||= "Closed"
    self.saturday_hours ||= "Closed"
    self.sunday.hours ||= "Closed"
  end

  def portland_address
    "#{self.address}, Portland, Oregon, USA"
  end

end
