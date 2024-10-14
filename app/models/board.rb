class Board < ApplicationRecord
    belongs_to :user
    has_many :comments, dependent: :destroy

    validates :place_name, presence: true
    validates :start_duration, presence: true
    validates :end_duration, presence: true
    validates :body, presence: true
    validates :budget , numericality: { only_integer: true }
end
