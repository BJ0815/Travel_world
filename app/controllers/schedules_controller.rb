class SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_suspend
  #排定行程method
  def new
    @wishLists = current_wish.wish_items.all
  end

  #搜尋行程default
  #根據前面輸入的國家和地點自動帶入(先寫死)
  def search
    @client = GooglePlaces::Client.new(GoogleKey)
    @spots= @client.spots_by_query('新店的餐廳',:language => 'zh-tw')
  end


  def search_spot
    @client = GooglePlaces::Client.new(GoogleKey)
    destination = params[:destination]
    spots= @client.spots_by_query(destination,:language => 'zh-tw')
    render :json => { :spots => spots }
  end

  #取照片要另外呼叫方法
  def get_spot_phtot
    @client = GooglePlaces::Client.new(GoogleKey)
    @spot = @client.spot(params[:place_id])
    url =  @spot.photos[0].fetch_url(800)
    render :json => { :url => url }
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
