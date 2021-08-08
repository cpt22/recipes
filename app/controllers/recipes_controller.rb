class RecipesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :delete]
  before_action :authorize_recipes

  def index
    items_per_page = Recipe::ITEMS_PER_PAGE
    page = params[:page] || 1
    if params[:search].present?
      @recipes = Recipe.search(params[:search], fields: ["name^10", "description^5", "content", "creator"], page: params[:page], per_page: items_per_page)
    else
      @recipes = Recipe.all.page(page)
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def new
  end

  def create
    if @recipe.update(permitted_attributes(Recipe))
      flash[:notice] = "Recipe created."
      redirect_to recipes_path
    else
      flash[:error] = "Recipe could not be created."
      render :action => :new
    end
  end

  def edit
  end

  def update
    begin
      attrs = permitted_attributes(@recipe)
      attrs[:categories] = attrs[:categories].reject{|c| c.blank?}.collect{|c| Category.find(c)}
      @recipe.update!(attrs)
      flash[:notice] = "Recipe updated."
      redirect_to edit_recipe_path(@recipe)
    rescue Exception
      flash[:error] = "Recipe could not be updated."
      render :action => :edit
    end
  end

  def destroy
    begin
      @recipe.destroy!
      flash[:notice] = "The recipe was deleted."
    rescue Exception => e
      flash[:error] = "The recipe could not be deleted. #{e.to_s}"
    end
    redirect_to recipes_path
  end

private

  def authorize_recipes
    case params[:action].to_sym
    when :new, :create
      @recipe = Recipe.new(user: current_user)
    when :edit, :update, :destroy
      @recipe = Recipe.find(params[:id])
    end
    authorize @recipe || Recipe
  end
end
