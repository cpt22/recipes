class RecipesController < ApplicationController
  before_action :authorize_recipes

  def index
    @recipes = Recipe.all
  end


private

  def authorize_recipes
    case params[:action].to_sym
    when :index
    else
    end
    authorize Recipe
  end
end
