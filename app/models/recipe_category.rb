class RecipeCategory < ApplicationRecord
  belongs_to :recipe, inverse_of: :recipe_categories
  belongs_to :category, inverse_of: :recipe_categories
end