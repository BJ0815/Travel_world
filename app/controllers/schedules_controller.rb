class SchedulesController < ApplicationController
  #排定行程method
  def new
    @wishLists = current_wish.wish_items.all
    #for 測試
    @event = Event.find(params[:event_id])

    @schedules = @event.schedules.all
    #@schedules = @event.schedules.all
  end

  def show
    @schedule = Schedule.find(params[:id])
    @Category = Category.all
    render :layout => false
  end

  #搜尋行程default
  #根據前面輸入的國家和地點自動帶入
  def search
    #puts params[:event_id]
    event = Event.find(params[:event_id])
    space =" "
    destination = event.country + space  + event.district + space + Category.first.name
    puts destination
    @client = GooglePlaces::Client.new(GoogleKey)
    @spots= @client.spots_by_query(destination,{ language: I18n.locale})
    @categories = Category.all
  end


  def search_spot
    @client = GooglePlaces::Client.new(GoogleKey)

    #category = Category.first
     category = Category.find_by(id:params[:category])

    if category.nil?
      #@category = Category.find(params[:category])
      destination = params[:destination]
    else
       destination = params[:destination] + category.name
    end

    spots = @client.spots_by_query( destination,:language => I18n.locale)
    render :json => { :spots => spots }
  end

  #取照片要另外呼叫方法
  def get_spot_phtot
    @client = GooglePlaces::Client.new(GoogleKey)
    @spot = @client.spot(params[:place_id], {detail: true,language: 'zh'})
    url =  @spot.photos[0].fetch_url(800)
    render :json => { :url => url, :resultSpot => @spot}
  end

  def add_to_wish
    @place_id = params[:placeId]
    @url = params[:url]
    #這裡寫法會再調整
    if !current_wish.add_wish_item(@place_id,@url)
      render :json => { :errors => "這個景點已在待選清單"},:status => 405
    else
      render :json => { :wishTems => current_wish.wish_items.last }
    end
  end

  def destroy_wish
    puts params[:id]
    @wish_item = WishItem.find(params[:id])
    @wish_item.destroy
    render :json => { :id => @wish_item.id }
  end
end
