class IngredientsController < ApplicationController
  before_action :authorize_ingredient

  def index
    @ingredients = Ingredient.all.order('name')
  end

  def new
  end

  def create
    if @ingredient.update(permitted_attributes(Ingredient))
      flash[:notice] = "Ingredient created."
      redirect_to ingredients_path
    else
      flash[:error] = "Ingredient could not be created."
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @ingredient.update(permitted_attributes(@ingredient))
      flash[:notice] = "Ingredient updated."
      redirect_to ingredients_path
    else
      flash[:error] = "Ingredient could not be updated."
      render :action => :edit
    end
  end

  def destroy
    begin
      if @ingredient.recipe_ingredients.count > 0
        flash[:error] = "You cannot delete an ingredient while it is used in recipes."
      else
        @ingredient.destroy!
        flash[:notice] = "The ingredient was deleted."
      end
    rescue Exception => e
      flash[:error] = "The ingredient could not be deleted. #{e.to_s}"
    end
    redirect_to ingredients_path
  end

private
  def authorize_ingredient
    case params[:action].to_sym
    when :new, :create
      @ingredient = Ingredient.new
    when :edit, :update, :destroy
      @ingredient = Ingredient.find(params[:id])
    end
    authorize(@ingredient || Ingredient)
  end
end
