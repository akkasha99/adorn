class Admin::BasicCategoriesController < Admin::AdminsController

  def index
    render :partial => 'all_categories', :locals => {:categories => BasicCategory.all}
  end

  def new
    render :partial => 'new_category', :locals => {:@category => BasicCategory.new}
  end

  def create
    if BasicCategory.create(basic_category_params)
      index
    else
      render :text => 'error'
    end
  end

  def edit
    @category = BasicCategory.find(params[:id]) if params[:id].present?
    render :partial => 'edit_category', :locals => {:@category => (@category if @category.present?)}
  end

  def update
    category = BasicCategory.find(params[:id]) if params[:id].present?
    category.update_attributes(basic_category_params) if category.present?
    index
  end

  def delete
    category = BasicCategory.find(params[:id]) if params[:id].present?
    category.destroy if category.present?
    index
  end

  private

  def basic_category_params
    params.require(:basic_category).permit(:name, :image)
  end
end
