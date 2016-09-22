class Admin::BasicSubcategoriesController < ApplicationController

  def index
    render :partial => 'all_subcategories', :locals => {:subcategories => BasicSubcategory.all}
  end

  def new
    render :partial => 'new_subcategory', :locals => {:categories => BasicCategory.all, :@subcategory => BasicSubcategory.new}
  end

  def new_subcategory
    render :partial => 'form', :locals => {:category_id => (params[:id] if params[:id].present?), :@subcategory => BasicSubcategory.new}
  end

  def create
    if BasicSubcategory.create(basic_subcategory_params)
      index
    else
      render :text => 'error'
    end
  end

  def edit
    @subcategory = BasicSubcategory.find(params[:id]) if params[:id].present?
    render :partial => 'edit_subcategory', :locals => {:@subcategory => (@subcategory if @subcategory.present?)}
  end

  def update
    subcategory = BasicSubcategory.find(params[:id]) if params[:id].present?
    subcategory.update_attributes(basic_subcategory_params) if subcategory.present?
    index
  end

  def delete
    subcategory = BasicSubcategory.find(params[:id]) if params[:id].present?
    subcategory.destroy if subcategory.present?
    index
  end

  private

  def basic_subcategory_params
    params.require(:basic_subcategory).permit(:name, :image, :basic_category_id)
  end

end
