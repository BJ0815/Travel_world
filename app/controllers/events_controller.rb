class EventsController < ApplicationController
  before_action :find_event, except: [:index, :search]
  before_action :authenticate_user!, except: [:index, :show, :search]

  def index
    @events = Event.all.order('favorites_count DESC').limit(5)
  end

  def show
    @infos = Event.includes(schedules: { details: :spot}).find(params[:id])
    @replies = @event.replies.all
    @reply = Reply.new
    #star rating 功能判別是否有reply，並算出star總平均
    if @replies.blank?
      @arg_num = 0
    else
      @arg_num = @replies.average(:number).round(2)
    end
  end

  def favorite
    current_user.favorites.create!(event: @event)

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path )}
      format.js
    end
  end

  def unfavorite
    current_user.favorites.where(event: @event).destroy_all

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path )}
      format.js
    end
  end

  def search

    #get event_type from session if it is blank
    params[:search] ||= session[:search]
    #save event_type to session for future requests
    session[:search] = params[:search]

    @events = Event.order_search_events(params[:search], params[:order]).page(params[:page]).per(10)

  end

  def clone
    @clone = @event.amoeba_dup
    if @clone.save!
      @org_user = EventsOfUser.find_org_user(@event)
      current_user.events_of_users.create!(event: @clone, org_user: @org_user)
    end
    redirect_back(fallback_location: root_path)
  end

  # 共享功能
  # def share
  #   @share = EventsOfUser.copy(@event)
  #   @share.update_attributes(user: current_user, creator: false)
  # end

  private

  def find_event
    @event = Event.find(params[:id])
  end


end
