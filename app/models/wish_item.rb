class WishItem < ApplicationRecord
  belongs_to :wish
  #geocoded_by :address        #從address欄位取出地址

  #after_validation :geocode   #將取出的地址自動轉為經緯度分別存在 latitude、longitude 欄位
end
