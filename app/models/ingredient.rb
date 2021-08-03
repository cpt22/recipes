class Ingredient < ApplicationRecord
  has_many :recipe_ingredients, inverse_of: :ingredient, dependent: :restrict_with_error
  has_many :recipes, through: :recipe_ingredients

  validates :name, presence: true
end
