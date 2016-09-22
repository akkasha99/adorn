class Admin::BrandsController < Admin::AdminsController

  def index
    render :partial => 'all_brands', :locals => {:brands => Brand.all}
  end

  def create
    if Brand.create(brand_params)
      render :partial => 'all_brands', :locals => {:brands => Brand.all}
    else
      render :text => 'error'
    end
  end

  def new
    render :partial => 'new_brand', :locals => {:@brand => Brand.new}
  end

  def edit
    @brand = Brand.find(params[:id]) if params[:id].present?
    render :partial => 'edit_brand', :locals => {:@brand => (@brand if @brand.present?)}
  end

  def update
    brand = Brand.find(params[:id]) if params[:id].present?
    brand.update_attributes(brand_params) if brand.present?
    #brand.update_attribute(:logo, params[:brand][:logo]) if brand.present?
    index
  end

  def delete
    brand = Brand.find(params[:id]) if params[:id].present?
    brand.destroy if brand.present?
    index
  end

  private

  def brand_params
    params.require(:brand).permit(:name, :logo)
  end

end
