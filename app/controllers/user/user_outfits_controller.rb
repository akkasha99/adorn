class User::UserOutfitsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create_outfit

  def user_outfits_list
    user = User.find(params[:uid]) if params[:uid].present?
    items = current_user.id == user.id ? (user.outfits_list(true) if user.present?) : (user.outfits_list(false) if user.present?)
    if (session[:webview] == '1')
      upload = (user == current_user ? true : false)
      render :partial => 'outfit_list', :locals => {:items => items, :upload => upload, :user_id => user.id}
    else
      render :partial => '/desktop/users/outfits_list', :locals => {:items => items, :user_id => user.id}
    end
  end

  def new_outfit
    @items =current_user.items_list(true) if current_user.present?
    render :partial => 'new_outfit', :locals => {:@outfit => UserOutfit.new}
  end

  def items_list
    items =current_user.items_list(true) if current_user.present?
    render :partial => 'items_list', :locals => {:items => items}
  end

  def create_outfit
    if params[:image].present?
      img = File.open("#{Rails.root}/public/outfit.png", 'wb') do |f|
        f.write(params[:image].read)
      end
      image_url = "#{Rails.root}/public/outfit.png"
    end
    render :partial => 'outfit_form', :locals => {:image_url => image_url, :outfit => UserOutfit.new}
  end

  def save_outfit
    if params[:user_outfit] != ""
      outfit = UserOutfit.create(user_outfit_params)
      outfit.update_attributes(:is_active => true, :image => File.open(params[:user_outfit][:image_url])) if params[:user_outfit][:image_url].present?
      #Adorn.create(:user_id => current_user.id, :user_outfit_id => outfit.id)#no need to adorn your own post

      params[:items].split(',').each { |id| OutfitItem.create(:user_item_id => id, :user_outfit_id => outfit.id) } if params[:items].present?
      params[:basics].split(',').each { |id| OutfitItem.create(:basic_item_id => id, :user_outfit_id => outfit.id) } if params[:basics].present?
      @featured_items = []
      outfit.user_items.map { |item| @featured_items << item } if outfit.present?
      outfit.basic_items.map { |item| @featured_items << item } if outfit.present?
      render :partial => 'outfit_show', :locals => {:@outfit => outfit}
      post_to_socials(params[:socials], outfit) if params[:socials].size > 0
    else
      render :text => 'error'
    end
  end

  def show
    @outfit = UserOutfit.find(params[:id]) if params[:id].present?
    @featured_items = []
    @outfit.user_items.map { |item| @featured_items << item } if @outfit.present?
    @outfit.basic_items.map { |item| @featured_items << item } if @outfit.present?
    if (session[:webview] == '1')
      render :partial => 'outfit_show'
    else
      render :partial => '/desktop/users/outfit', :locals => {:@outfit => @outfit, :suggested => @featured_items}
    end
  end

  def outfit_delete
    user_outfit = UserOutfit.find(params[:id]) if params[:id].present?
    mention = Mention.where(:content_type => 'outfit', :content_id => user_outfit.id)
    mention.each do |mention|
      mention.destroy!
    end
    user_outfit.destroy! if user_outfit.present?
    user = User.find(params[:user_id]) if params[:user_id].present?
    render :partial => '/user/users/user_closet', :locals => {:@user => user}
  end

  def edit_outfit
    outfit = UserOutfit.find(params[:id]) if params[:id].present?
    render :partial => 'outfit_form', :locals => {:outfit => outfit}
  end

  def update_outfit
    outfit = UserOutfit.find(params[:id]) if params[:id].present?
    outfit.update_attributes(user_outfit_params) if outfit.present?
    show
    #render :text => "/user/outfit/show/#{outfit.id}" if outfit.present?
  end

  def feed_adoorning
    outfit = UserOutfit.find(params[:outfit_id]) if params[:outfit_id].present?
    if outfit.is_adoorned(params[:user_id])
      adorn = Adorn.where(:user_id => current_user.id, :user_outfit_id => outfit.id).first
      mention = Mention.where(:by_user => current_user.id, :content_type => 'outfit', :content_id => outfit.id).first if current_user.id != outfit.user_id
      adorn.destroy if adorn.present?
      mention.destroy if mention.present?
    else
      Adorn.create(:user_id => current_user.id, :user_outfit_id => outfit.id) if outfit.id.present?
      Mention.create(:user_id => outfit.user_id, :by_user => current_user.id, :content_type => 'outfit', :mention_type => 'adoorned', :content_id => params[:outfit_id]) if outfit.present? && current_user.id != outfit.user_id
    end
    if params[:type]=='feed'
      if (session[:webview] == '1')
        render :partial => 'user/users/feed_adorns_buttons', :locals => {:feed => outfit}
      else
        render :partial => 'desktop/users/feed_buttons', :locals => {:feed => outfit}
      end
    else
      render :partial => 'outfit_adoorn_buttons', :locals => {:@outfit => outfit}
    end
  end

  def comments
    outfit = UserOutfit.find(params[:outfit_id]) if params[:outfit_id].present?
    @comments = outfit.comments
    @outfit_id = outfit.id if outfit.present?
    render :partial => 'comments', :locals => {:@comments => outfit.comments, :@outfit_id => params[:outfit_id]}
  end

  def add_comments
    Comment.create(comment_params)
    outfit = UserOutfit.where(:id => params[:item_id]).first if params[:item_id].present?
    Mention.create(:user_id => outfit.user_id, :by_user => current_user.id, :content_type => 'outfit', :mention_type => 'commented', :content_id => params[:item_id]) if outfit.present? && current_user.id != outfit.user_id
    @comments = outfit.comments
    @outfit_id = params[:comment][:user_outfit_id]
    if (session[:webview] == '1')
      render :partial => 'comments', :locals => {:@comments => outfit.comments, :@outfit_id => @outfit_id}
    else
      @feed = outfit
      div = 'comments_' + outfit.class.name + '_' + outfit.id.to_s
      if params[:outfit].present?
        render :partial => "/desktop/users/comments", :locals => {:comment => @comments, :@item => outfit}
      else
        render :json => {:div => div, :partial => render_to_body(:file => "#{Rails.root}/app/views/desktop/users/_all_comments.html.erb")}
      end
    end
  end

  def get_item_data
    item =UserItem.find(params[:id]) if params[:id].present?
    hash = {:url => item.image.url(:icon), :id => item.id}
    if hash.present?
      render :json => hash
    else
      render :text => 'error'
    end
  end

  def select_basics
    categories = BasicCategory.all
    sorted_cat = sort_categories(categories)
    render :partial => 'add_basics', :locals => {:categories => (sorted_cat.size > 0 ? sorted_cat : [])}
  end

  def select_basic_subcategories
    categories = BasicSubcategory.where(basic_category_id: params[:id]) if params[:id].present?
    render :partial => 'basic_tees', :locals => {:categories => (categories.size > 0 ? categories : [])}
  end

  def select_basic_items
    category = BasicCategory.find(params[:id]) if params[:id].present?
    items = category.basic_subcategories if category.present?
    render :partial => 'basic_tees', :locals => {:items => (items.size > 0 ? items : []), :name => category.name}
  end

  #def select_basic_items
  #  basic_category = BasicSubcategory.find(params[:id]) if params[:id].present?
  #  items = basic_category.basic_items.where(:color => "#000").first if basic_category.present?
  #  render :partial => 'basic_tees', :locals => {:item => basic_category, :name => basic_category.name, :items => items}
  #  #item = basic_category.basic_items.where(:color => "#000").first
  #  #render :partial => 'basic_tees', :locals => {:item => basic_category, :item1 => items, :name => basic_category.name, :items => items}
  #end

  def show_basic_item
    subcategory = BasicSubcategory.find(params[:id]) if params[:id].present?
    item = subcategory.basic_items.where(:color => params[:color]).first if subcategory.present? && params[:color].present?
    if item.present?
      render :partial => 'image_template', :locals => {:item => item}
    else
      render :partial => 'image_template', :locals => {:item => subcategory}
    end
  end

  def sort_categories(cat)
    sorted_cat = []
    tt = cat.where(:name => "Tops")
    sorted_cat += tt
    tt = cat.where(:name => "BOTTOMS")
    sorted_cat += tt
    tt = cat.where(:name => "Skirts Dresses")
    tt[0].name = "Skirts & Dresses"
    sorted_cat += tt
    tt = cat.where(:name => "Outerwear")
    sorted_cat += tt
    tt = cat.where(:name => "Accessories")
    sorted_cat += tt
    sorted_cat
  end

  #def add_to_closet
  #  outfit = UserOutfit.find(params[:id])
  #  outfit_items = outfit.outfit_items
  #  u_outfit = UserOutfit.new
  #  u_outfit.title = outfit.title if item.title.present?
  #  u_outfit.description = outfit.description if item.description.present?
  #  u_outfit.private_flag = 0
  #  u_outfit.user_id = current_user.id
  #  u_outfit.is_active = true
  #  u_outfit.price = outfit.price if item.price.present?
  #  u_outfit.buy_link = outfit.buy_link if item.buy_link.present?
  #  u_outfit.image = outfit.image if outfit.image.present?
  #  puts "ZZZZZZZZZZZZZZZZZZZZZZZZZ", u_outfit.inspect
  #  asdadasd
  #  u_outfit.save!
  #  render :partial => '/user/users/user_closet', :locals => {:@user => current_user}
  #
  #end


  private

  def user_outfit_params
    params.require(:user_outfit).permit(:title, :private_flag, :description, :user_id, :image)
  end

  def comment_params
    params.require(:comment).permit(:text, :user_id, :user_item_id, :user_blog_id, :user_outfit_id)
  end

end
