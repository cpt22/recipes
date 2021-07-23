class RecipeIngredient < ApplicationRecord
  belongs_to :recipe, inverse_of: :RecipeIngredient
  belongs_to :ingredient
end