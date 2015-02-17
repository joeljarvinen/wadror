class Beer < ActiveRecord::Base
  include RatingAverage

  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user

  validates :name, presence: true, allow_blank: false
  validates :style, presence: true

  def to_s
    "#{name} from #{brewery.name}"
  end

  def self.top(n)
    sorted_by_rating_in_desc_order = Beer.all.sort_by { |b| -(b.average_rating||0) }
    sorted_by_rating_in_desc_order.take(n)
  end
end
