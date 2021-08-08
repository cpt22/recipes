class Recipe < ApplicationRecord
  has_rich_text :content

  belongs_to :user

  has_many :recipe_ingredients, inverse_of: :recipe, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :recipe_categories, inverse_of: :recipe, dependent: :destroy
  has_many :categories, through: :recipe_categories

  has_one_attached :main_image

  accepts_nested_attributes_for :recipe_ingredients, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true
  validates :main_image, content_type: [:png, :jpg, :jpeg]

  audited
  searchkick

  ITEMS_PER_PAGE = 15.freeze

  paginates_per ITEMS_PER_PAGE


  def search_data
    attributes.merge(
      category_name: categories.map(&:name)
    )
  end
end
