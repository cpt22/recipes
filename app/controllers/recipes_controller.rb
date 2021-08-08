class RecipesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :delete]
  before_action :authorize_recipes

  def index
    items_per_page = Recipe::ITEMS_PER_PAGE
    page = params[:page] || 1
    search = params[:search]
    category = Category.find(params[:category]).try(:name) if params[:category].present?
    if search.present? && category.present?
      @recipes = Recipe.search(search, where: {category_name: category}, fields: ["name^10", "description^5", "content", "creator"], page: params[:page], per_page: items_per_page)
    elsif search.present?
      @recipes = Recipe.search(search, fields: ["name^10", "description^5", "content", "creator"], page: params[:page], per_page: items_per_page)
    elsif category.present?
      @recipes = Recipe.search("*", where: {category_name: category}, fields: ["name^10", "description^5", "content", "creator"], page: params[:page], per_page: items_per_page)
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
    attrs = permitted_attributes(Recipe)
    attrs[:categories] = normalize_categories attrs[:categories]
    if @recipe.update(attrs)
      flash[:notice] = "Recipe created."
      redirect_to recipe_path(@recipe)
    else
      flash[:error] = "Recipe could not be created."
      render :action => :new
    end
  end

  def edit
  end

  def update
    attrs = permitted_attributes(@recipe)
    attrs[:categories] = normalize_categories attrs[:categories]
    begin
      @recipe.update!(attrs)
      flash[:notice] = "Recipe updated."
      redirect_to recipe_path(@recipe)
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

  ##
  # Replace category IDs with the actual +Category+ objects.
  # [attributes] (List of String) The list of IDs to convert to +Category+ objects.
  # Returns a list of +Category+ objects
  def normalize_categories(attributes)
    return attributes.reject{|c| c.blank?}.collect{|c| Category.find(c)}
  end

end
