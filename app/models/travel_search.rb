# frozen_string_literal: true

class TravelSearch
  include ActiveModel::Model
  attr_accessor :number, :gender, :age, :budget, :in_or_out, :departure, :hobby

  validates :number, :gender, :age, :budget, :in_or_out, presence: true
  validates :departure, :hobby, length: { maximum: 20, message: 'は20文字以内で入力してください' }
end
