# frozen_string_literal: true

class User < ApplicationRecord
  authenticates_with_sorcery!
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [50, 50]
  end
  has_many :comments, dependent: :destroy
  has_many :savings, dependent: :destroy

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true

  def avatar_url(variant: nil)
    if avatar.attached?
      if variant
        Rails.application.routes.url_helpers.rails_representation_url(avatar.variant(variant),
                                                                      only_path: true)
      else
        Rails.application.routes.url_helpers.rails_blob_path(
          avatar, only_path: true
        )
      end
    else
      ActionController::Base.helpers.asset_path('default_avatar.JPG')
    end
  end

  def own?(object)
    id == object&.user_id
  end
end
