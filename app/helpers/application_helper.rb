module ApplicationHelper
  def flash_class(level)
    case level
      when :notice then
        "alert alert-info"
      when :success then
        "alert alert-success"
      when :error then
        "alert alert-error"
      when :alert then
        "alert alert-error"
    end
  end

  def resource_class
    devise_mapping.to
  end

  def is_adoorn(id)
    user = User.find(id) if id.present?
    if user.adoorners.include?(current_user)
      return true
    else
      return false
    end
  end

  def is_item_adoorn(item_id)
    item = UserItem.find(item_id) if item_id.present?
    if item.adorns.where(:user_id => current_user.id).present?
      return true
    else
      return false
    end

  end

  def is_outfit_adoorn(outfit_id)
    outfit = UserOutfit.find(outfit_id) if outfit_id.present?
    if outfit.adorns.where(:user_id => current_user.id).present?
      return true
    else
      return false
    end
  end

  def check_connection(provider)
    if current_user.has_connection_with(provider)
      true
    else
      false
    end
  end
end
