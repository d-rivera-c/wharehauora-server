class Suburb < ActiveRecord::Base
  validates :name, presence: true
  has_many :homes
  # belongs_to :city
end
