class User::UserItemsController < User::UsersController
  require 'xml'
  require 'net/http'
  require "xmlrpc/server"
  require "xmlrpc/client"
  require 'open-uri'
  require 'uri'

  skip_before_filter :verify_authenticity_token


  include LibXML

  def user_items_list
    user = User.find(params[:id]) if params[:id].present?
    items = current_user.id == user.id ? (user.items_list(true) if user.present?) : (user.items_list(false) if user.present?)
    if (session[:webview] == '1')
      upload = (user == current_user ? true : false)
      render :partial => 'user_items_list', :locals => {:items => items, :upload => upload}
    else
      render :partial => '/desktop/users/items_list', :locals => {:items => items, :upload => upload}
    end
  end

  def open_search
    # @items = current_user.items_list(true) if current_user.present?
    render :partial => 'search_items'
  end

  def search_items
    items = []
    sem3 = Semantics3::Products.new('SEM368D1E63F0661D9A3344CE04D62937432', 'NTA1NzNmZTYxMTU4N2I2OGEzMzFkZDBjZWI3Mjc2ODU')
    sem3.products_field("search", params[:key])
    sem3.products_field("cat_id", 17366)
    # sem3.products_field("sort", "price", "asc" )
    productsHash = sem3.get_products()
    # puts productsHash.to_json
    # puts "Results of query:\n", productsHash.to_json
    if productsHash['results_count'].to_i > 0
      if productsHash['code'] == "OK" && productsHash['results'].size > 0
        items += productsHash['results']
        # puts "items -------------- " , items.inspect
      end
    end
    # puts 'eqrewrq werq wer erw', items.first.inspect
    # puts 'eqrewrq werq wer erw', items.first['images'].first.to_s.inspect

    render :partial => 'search_item_result', :locals => {:items => items}
  end

  def search_more
    # puts "ssd", params.inspect
    items = []
    sem3 = Semantics3::Products.new('SEM368D1E63F0661D9A3344CE04D62937432', 'NTA1NzNmZTYxMTU4N2I2OGEzMzFkZDBjZWI3Mjc2ODU')
    sem3.products_field("search", params[:key])
    sem3.products_field("cat_id", 17366)
    sem3.products_field("offset", params[:offset])

    productsHash = sem3.get_products()

    # puts "342342342v 234234 2342342 ", productsHash.inspect

    if productsHash['results_count'].to_i > 0
      if productsHash['code'] == "OK" && productsHash['results'].size > 0
        items += productsHash['results']
        # puts "items -------------- ", items.inspect
      end
    end
    # puts 'eqrewrq werq wer erw', items.first.inspect
    # puts 'eqrewrq werq wer erw', items.first['images'].first.to_s.inspect

    render :partial => 'search_item_result', :locals => {:items => items}


  end

  def upload_item
    @item = UserItem.new
    render :partial => 'upload_item', :locals => {:@item => @item}
  end

  def add_item_pic
    img = "temp_item.jpg"
    if params[:image].present?
      img = "temp_item." + params[:image].content_type.split('/')[1]
      FileUtils.mv(params[:image].tempfile.path, "#{Rails.root}/tmp/"+ img)
    end
    @item = UserItem.new #(user_item_params)
    render :partial => 'add_item', :locals => {:@item => @item, :image => img}
  end

  def create
    # puts "hhhhhhhhhhhhhhhhhhhh"
    if params[:user_item] != ""
      if params[:user_item] != ""
        item = UserItem.new(user_item_params)
        if params[:image_path].present?
          img_path = params[:image_path].split(".")[0]
          if img_path == "temp_item"
            uri = URI.parse(params[:image_path])
            filename = File.basename(uri.path)
            #file = File.open("#{Rails.root}/tmp/" + params[:image_path], 'wb')
            #open("#{Rails.root}/tmp/" + filename, 'wb') do |file|
            #  file << File.open(params[:image_path]).read
            #end
            item.image = File.new("#{Rails.root}/tmp/" + filename) if params[:image_path].present?
          else
            item.picture_from_url(params[:image_path])
          end
        end
        item.save!
        # Adorn.create(:user_id => current_user.id, :user_item_id => item.id) #no need to adorn your post
        @suggested_items = UserItem.all.sample(6)
        render :partial => 'item_show', :locals => {:@item => item} if item.present?
        # puts "ooooooooooooooooo"
        post_to_socials(params[:socials], item) if params[:socials].size > 0
      else
        render :text => 'error'
      end
    end
  end

  def show
    @item = UserItem.find(params[:id]) if params[:id].present?
    if (session[:webview] == '1')
      @suggested_items = UserItem.all.sample(6)
      render :partial => 'item_show'
    else
      @suggested_items = UserItem.all.sample(9)
      render :partial => '/desktop/users/item', :locals => {:@item => @item, :suggested => @suggested_items}
    end
  end

  def item_delete
    user_item = UserItem.find(params[:id]) if params[:id].present?
    mention = Mention.where(:content_type => 'item', :content_id => user_item.id)
    mention.each do |mention|
      mention.destroy!
    end
    user_item.destroy! if user_item.present?
    user = User.find(params[:user_id]) if params[:user_id].present?
    render :partial => '/user/users/user_closet', :locals => {:@user => user}
  end

  def feed_adoorning
    item = UserItem.find(params[:item_id]) if params[:item_id].present?
    if item.is_adoorned(params[:user_id])
      adorn = Adorn.where(:user_id => current_user.id, :user_item_id => item.id).first
      mention = Mention.where(:by_user => current_user.id, :content_type => 'item', :content_id => item.id).first if current_user.id != item.user_id
      adorn.destroy if adorn.present?
      mention.destroy if mention.present?
    else
      Adorn.create(:user_id => current_user.id, :user_item_id => item.id) if item.id.present?
      Mention.create(:user_id => item.user_id, :by_user => current_user.id, :content_type => 'item', :mention_type => 'adoorned', :content_id => params[:item_id]) if item.present? && current_user.id != item.user_id
    end
    if params[:type]== 'feed'
      if (session[:webview] == '1')
        render :partial => 'user/users/feed_adorns_buttons', :locals => {:feed => item}
      else
        render :partial => 'desktop/users/feed_buttons', :locals => {:feed => item}
      end
    else
      if (session[:webview] == '1')
        render :partial => 'item_adoorn_buttons', :locals => {:@item => item}
      else
        render :partial => 'desktop/users/item_buttons', :locals => {:@item => item}
      end
    end
  end

  def comments
    @item = UserItem.find(params[:id]) if params[:id].present?
    @comments = @item.comments
    @item_id = params[:id] if params[:id].present?
    render :partial => 'comments'
  end

  def add_comments
    Comment.create(comment_params)
    item = UserItem.find(params[:item_id]) if params[:item_id].present?
    Mention.create(:user_id => item.user_id, :by_user => current_user.id, :content_type => 'item', :mention_type => 'commented', :content_id => params[:item_id]) if item.present? && current_user.id != item.user_id
    @comments = item.comments
    @item_id = item.id if item.present?
    if session[:webview] == '1'
      render :partial => 'comments'
    else
      @feed = item
      div = 'comments_' + item.class.name + '_' + item.id.to_s
      if params[:item].present?
        render :partial => "/desktop/users/comments", :locals => {:comment => @comments, :@item => item}
      else
        render :json => {:div => div, :partial => render_to_body(:file => "#{Rails.root}/app/views/desktop/users/_all_comments.html.erb")}
      end
    end
  end

  def read_image
    # img = "#{params[:image]}" #{Rails.root}/tmp/"+ img
    @item = UserItem.new
    # img = "temp_item.jpg" # + params[:image]
    # FileUtils.copy(params[:image], "#{Rails.root}/tmp/"+ img)
    # binary_data = Base64.decode64(params[:image])
    # puts "sssssssssssssss" , binary_data.inspect
    File.open('file_name1.JPEG', 'w') { |f| f.write(params[:image]) }
    # File.binwrite("fffff5.bmp", params[:image])
    render :partial => 'add_item', :locals => {:@item => @item, :image => img}
  end


  def android_image_up
    binary_data = Base64.decode64(params[:image])
    begin
      File.open("#{Rails.root}/tmp/temp_item.jpg", 'wb') { |f| f.write(binary_data) }
    rescue Exception => e
      # puts "sssssseeeeeeeeeeeeeeeee", e.message
    end
    render :json => {:success => true, :message => "Image Saved."}
  end


  def edit_item
    item = UserItem.find(params[:id]) if params[:id].present?
    render :partial => 'add_item', :locals => {:@item => item}
  end

  #
  def update_item
    item = UserItem.find(params[:id]) if params[:id].present?
    item.update_attributes(user_item_params) if item.present?
    post_to_socials(params[:socials], item) if params[:socials].size > 0
    show
    #render :text => "/user/item/show/#{item.id}" if item.present?
    #render :partial => 'item_show', :locals => {:@item => item}
  end

  def item_details
    sem3 = Semantics3::Products.new('SEM368D1E63F0661D9A3344CE04D62937432', 'NTA1NzNmZTYxMTU4N2I2OGEzMzFkZDBjZWI3Mjc2ODU')
    upccode = params[:upc].split(' ').last if params[:upc].present?
    #upccode = '0080665001765'
    # p "uuuuuuuuuuuuuu", upccode
    #sem3.products_field("gtins", upccode)
    sem3.products_field("upc", upccode)
    #sem3.products_field("ean", upccode)
    sem3.products_field("field", ["name", "gtins"])
    productsHash = sem3.get_products
    # puts "Results of query:\n", productsHash.to_json
    if productsHash['results_count'].to_i > 0
      if productsHash['code'] == "OK" && productsHash['results'].size > 0
        obj = productsHash['results'].first
        item = UserItem.new(:title => productsHash['results'].first['name'], :price => productsHash['results'].first['price'].to_f, :is_active => true, :private_flag => false, :buy_link => productsHash['results'].first['sitedetails'].first['url'])
        if obj['images_total'] > 0
          image = obj['images'].first
        else
          image = nil
        end
      else
        detail = "Image url is missing. Take picture to continue."
      end
    else
      detail = "No results found. Try adding a photo."
    end
    if item.present?
      render :partial => 'add_item', :locals => {:@item => item, :image => image}
    else
      render :json => {:success => false, :detail => detail}
    end
  end

  def sementic_result
    item = UserItem.new(:title => params[:title], :price => params[:price].to_f, :is_active => true, :private_flag => false, :buy_link => params[:buy_link])
    render :partial => 'add_item', :locals => {:@item => item, :image => params[:image]}
  end

  #def upc_details
  #  upccode = params[:upc].split(' ')[1] if params[:upc].present?
  #  net = Net::HTTP.new("www.upcdatabase.com", 80)
  #  key = 'b54a1cf9b41fe78be2824ac4d1a2e2ad14ea58f0';
  #  #upccode = '021200705007'
  #  p "uuuuuuuuuu", upccode
  #  server = XMLRPC::Client.new("www.upcdatabase.com", "/xmlrpc")
  #  result = server.call('lookup', 'rpc_key' => key, 'upc' => upccode)
  #  puts "Result : ", result
  #  render :text => result.to_json
  #end

  def item_private
    item = UserItem.find(params[:item_id])
    if params[:status] == "true"
      item.update_attributes(:private_flag => false) if item.present?
    else
      item.update_attributes(:private_flag => true) if item.present?
    end
    item = UserItem.find(params[:item_id])
    render :partial => 'private', :locals => {:@item => item}
  end

  def add_to_closet
    item = UserItem.find(params[:id])
    u_item = UserItem.new
    u_item.title = item.title if item.title.present?
    u_item.description = item.description if item.description.present?
    u_item.private_flag = 0
    u_item.user_id = current_user.id
    u_item.is_active = true
    u_item.price = item.price if item.price.present?
    u_item.buy_link = item.buy_link if item.buy_link.present?
    u_item.image = item.image if item.image.present?
    u_item.save!
    render :partial => '/user/users/user_closet', :locals => {:@user => current_user}
  end

  #def read_image
  #  puts "AAAAAAAAAAAAAAAAA", params.inspect
  #  img = "#{params[:image]}" #{Rails.root}/tmp/"+ img
  #  @item = UserItem.new
  #  puts "AAAAAAAAAAAAAAAAAAAAAAA", img.inspect
  #  File.binwrite("fffff5.bmp", params[:image])
  #  render :partial => 'add_item', :locals => {:@item => @item, :image => img}
  #end

  private

  def user_item_params
    params.require(:user_item).permit(:title, :description, :user_id, :image, :price, :private_flag, :buy_link)
  end

  def comment_params
    params.require(:comment).permit(:text, :user_id, :user_item_id, :user_blog_id, :user_outfit_id)
  end

end
