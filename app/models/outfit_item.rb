class OutfitItem < ActiveRecord::Base
  belongs_to :user_item
  belongs_to :basic_item
  belongs_to :user_outfit
end
