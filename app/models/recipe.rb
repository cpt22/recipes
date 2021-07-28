class Recipe < ApplicationRecord
  has_rich_text :content

  belongs_to :user

  has_many :recipe_ingredients, inverse_of: :recipe
  has_many :ingredients, through: :recipe_ingredients
  has_many :recipe_categories, inverse_of: :recipe
  has_many :categories, through: :recipe_categories

  audited
end
