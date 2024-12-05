# frozen_string_literal: true

class TravelSearch
  include ActiveModel::Model
  attr_accessor :number, :gender, :age, :budget

  validates :number, :gender, :age, :budget, presence: true
end
