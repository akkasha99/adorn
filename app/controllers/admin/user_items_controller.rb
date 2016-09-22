class Admin::UserItemsController < Admin::AdminsController

  def index
    users = User.all.map { |u| u if (u.isactive == true && !u.admin?) }.compact!
    render :partial => 'user_items', :locals => {:users => users}
  end

  def get_user_items
    user = User.find(params[:id]) if params[:id].present?
    items = (user.present? ? user.user_items : [])
    render :partial => 'items_partial', :locals => {:items => items, :user_id => (user.id if user.present?)}
  end

  def change_item_control
    user = User.find(params[:user_id]) if params[:user_id].present?
    item = UserItem.find(params[:id]) if params[:id].present?
    if item.present?
      if item.is_active == false
        item.update_attribute('is_active', true)
      else
        item.update_attribute('is_active', false)
      end
    end
    items = (user.present? ? user.user_items : [])
    render :partial => 'items_partial', :locals => {:items => items, :user_id => (user.id if user.present?)}
  end
end
