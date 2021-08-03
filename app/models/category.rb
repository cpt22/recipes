class Category < ApplicationRecord
  has_many :recipe_categories, inverse_of: :category, dependent: :restrict_with_error
  has_many :recipes, through: :recipe_categories

  validates :name, presence: true, uniqueness: true
end
