class Favorite < ApplicationRecord
  belongs_to :event, counter_cache: true
  belongs_to :user
  validates :user, uniqueness: { scope: :event }
end
