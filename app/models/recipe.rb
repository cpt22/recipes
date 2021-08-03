class Recipe < ApplicationRecord
  has_rich_text :content

  belongs_to :user

  has_many :recipe_ingredients, inverse_of: :recipe, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :recipe_categories, inverse_of: :recipe, dependent: :destroy
  has_many :categories, through: :recipe_categories

  accepts_nested_attributes_for :recipe_ingredients, allow_destroy: true

  audited
end
