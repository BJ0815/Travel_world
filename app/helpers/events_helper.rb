module EventsHelper

  def favorited?(event, user)
    event.favorites.where(user: user).exists?
  end

  def clone?(event, user)
    org_user = EventsOfUser.find_by(event: event).user
    EventsOfUser.where(user_id: user, org_user: org_user, org_event: event).exists? || 
    user.cloned_events.where(id: event).exists?
  end

  def myEvent?(event, user)
    if user.present?
      user.contributed_events.where(id: event).exists?
    end
  end

  def is_your_event?(event, user)
    event.users.where(id: user.id).exists?
  end

  def org_user_name(event)
    org_user = EventsOfUser.find_by(event: event).org_user
    User.find(org_user).name
  end

  def spot_img(event)
    event.schedules.first.spots.first ? event.schedules.first.spots.first.getPhoto.first : ENV['DEFAULT_IMAGE']
  end

  def privacy_valid?(event, user)
    if @event.privacy
      if user
        event.users.find_by(id: user.id).blank? 
      else
        true
      end
    end
  end

end
