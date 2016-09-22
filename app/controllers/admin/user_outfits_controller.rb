class Admin::UserOutfitsController < ApplicationController

  def index
    users = User.all.map { |u| u if (u.isactive == true && !u.admin?) }.compact!
    render :partial => 'outfits_index', :locals => {:users => users}
  end

  def get_outfits
    user = User.find(params[:id]) if params[:id].present?
    outfits = (user.present? ? user.user_outfits : [])
    render :partial => 'outfits_list', :locals => {:items => outfits, :user_id => (user.id if user.present?)}
  end

  def outfit_activity
    user = User.find(params[:user_id]) if params[:user_id].present?
    outfit = UserOutfit.find(params[:id]) if params[:id].present?
    if outfit.present?
      if outfit.is_active == false
        outfit.update_attribute('is_active', true)
      else
        outfit.update_attribute('is_active', false)
      end
    end
    outfits = (user.present? ? user.user_outfits : [])
    render :partial => 'outfits_list', :locals => {:items => outfits, :user_id => (user.id if user.present?)}
  end

end
