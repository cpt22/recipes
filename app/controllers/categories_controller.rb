class CategoriesController < ApplicationController
  before_action :authorize_category

  def index
    @categories = Category.all.order('name')
  end

  def create
    if @category.update(permitted_attributes(Category))
      flash[:notice] = "Category created."
      redirect_to categories_path
    else
      flash[:error] = "Category could not be created."
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @category.update(permitted_attributes(@category))
      flash[:notice] = "Category updated."
      redirect_to categories_path
    else
      flash[:error] = "Category could not be updated."
      render :action => :edit
    end
  end

  def destroy
    begin
      if @category.recipe_categories.count > 0
        flash[:error] = "You cannot delete a category that is associated with recipes."
      else
        @category.destroy!
        flash[:notice] = "The category was deleted."
      end
    rescue Exception => e
      flash[:error] = "The category could not be deleted. #{e.to_s}"
    end
    redirect_to categories_path
  end

private
  def authorize_category
    case params[:action].to_sym
    when :new, :create
      @category = Category.new
    when :edit, :update, :destroy
      @category = Category.find(params[:id])
    end
    authorize(@category || Category)
  end
end
