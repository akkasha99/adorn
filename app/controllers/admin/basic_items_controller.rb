class Admin::BasicItemsController < Admin::AdminsController

  def index
    render :partial => 'all_items', :locals => {:items => BasicItem.all}
  end

  def new
    render :partial => 'new_item', :locals => {:categories => BasicCategory.all}
  end

  def new_item
    render :partial => 'item_form', :locals => {:subcategory_id => (params[:id] if params[:id].present?), :@item => BasicItem.new}
  end

  def create
    if params[:basic_item] != ""
      BasicItem.create(basic_item_params)
      index
    else
      render :text => 'error'
    end
  end

  def edit
    @item = BasicItem.find(params[:id]) if params[:id].present?
    render :partial => 'edit_item', :locals => {:@item => (@item if @item.present?)}
  end

  def update
    item = BasicItem.find(params[:id]) if params[:id].present?
    item.update_attributes(basic_item_params) if item.present?
    index
  end

  def delete
    item = BasicItem.find(params[:id]) if params[:id].present?
    item.destroy if item.present?
    index
  end

  def basic_categories
    category = BasicCategory.find(params[:id])
    subcategories = category.basic_subcategories
    render :partial => 'subcategories', :locals => {:subcategories => subcategories}
  end

  private

  def basic_item_params
    params.require(:basic_item).permit(:title, :price, :description, :basic_subcategory_id, :image, :color)
  end
end
