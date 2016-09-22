class HomeController < ApplicationController
  layout 'application'
  before_action :route?, :except => [:featured_brands, :featured_bloggers, :fav_brands, :fav_bloggers, :terms_of_services, :privacy_policy] # :authenticate_user!,

  def featured_brands
    @brands = Brand.all
  end

  def fav_brands
    user = User.find(params[:user_id]) if params[:user_id].present?
    if params[:list].present?
      params[:list].split(',').each { |id| FavBrand.create!(:brand_id => id, :user_id => user.id) if user.present? && id != nil }
    end
    render :partial => "/home/featured_bloggers", :locals => {:user_id => user.id, :@bloggers => User.where(:is_featured => true)}
  end

  def featured_bloggers
    @bloggers = User.where(:is_featured => true, :isactive => true)
  end

  def fav_bloggers
    user = User.find(params[:user_id]) if params[:user_id].present?
    if params[:list].present?
      params[:list].split(',').each { |id| follow_blogger(user.id, id) if user.present? && id != nil }
    end
    flash[:notice] = "You are successfully registered, Sign IN to continue."
    render :text => "/users/sign_in"
  end

  def terms_of_services

  end

  def privacy_policy

  end

end

private

def route?
  if user_signed_in?
    redirect_to admin_path if current_user.admin?
    redirect_to '/newsfeed' if current_user.user?
  else
    redirect_to '/users/sign_in'
  end
end

def follow_blogger(uid, id)
  adoorner = UserAdoorner.create(:adoorner_id => uid, :user_id => id) if id.present?
  Mention.create(:user_id => id, :by_user => uid, :content_type => 'user', :mention_type => 'adoorning') if adoorner.present?
end
