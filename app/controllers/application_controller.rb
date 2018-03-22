class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_wish
  #設定expore time
  helper_method :check_expires


  #設定待選清單
  private
  def current_wish
    @wish || set_wish # return @wish if @wish exist, or call set_wish
  end

  def set_wish

    if session[:wish_id]
      @wish = Wish.find_by(id: session[:wish_id])
    end

    @wish ||= Wish.create

    session[:wish_id] = @wish.id
    session[:expires_at] = Time.current + 2.hours
    @wish
  end

  #判斷待選清單的expire time,超過時間就刪除
  def check_expires
    if session[:expires_at] < Time.current
      #destroy wish
      @wish = Wish.find_by(id: session[:wish_id])
      @wish.destroy
    end

  end

end
