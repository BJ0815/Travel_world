class Event < ApplicationRecord
  has_many :events_of_users, dependent: :destroy
  has_many :users, through: :events_of_users
  
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :replies, -> {order("created_at DESC")}, dependent: :destroy

  has_many :schedules, -> {order("day ASC")}, dependent: :destroy

  validates_presence_of :country, :title

  amoeba do
    exclude_association :events_of_users
    exclude_association :favorites
    exclude_association :replies
    clone :schedules
    propagate
    set :replies_count => 0
  end

  def self.all_of_org_events
    #顯示全部（複製的除外）
    Event.joins(:events_of_users).where('org_user = user_id')
  end

  def self.search_events(params)
    return all_of_org_events if params.blank?
    all_of_org_events.where("title LIKE ? OR country LIKE ? OR district LIKE ?", "%#{params}%", "%#{params}%", "%#{params}%")
  end

  def self.order_search_events(search, order)
    if order.blank?
      search_events(search).order("created_at DESC")
    else
      search_events(search).order("#{order} DESC")
    end
  end
end
