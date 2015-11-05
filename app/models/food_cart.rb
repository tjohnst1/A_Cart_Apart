class FoodCart < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search, against: [:name, :address ],
                           using: { tsearch: { prefix: true, dictionary: "english" }},
                           ignoring: [:accents]

  geocoded_by :address
  after_validation :geocode

  has_many :tags
  has_many :reviews
  validates :name, presence: true
  validates :address, presence: true

  def self.text_search(query)
    if query.present?
      search(query)
    else
      FoodCart.all
    end
  end

end
