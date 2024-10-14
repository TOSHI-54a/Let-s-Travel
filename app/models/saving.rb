class Saving < ApplicationRecord
  belongs_to :user
  validates :value, presence: true, numericality: { greater_than: 0 }
end
