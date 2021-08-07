class RecipeIngredient < ApplicationRecord
  belongs_to :recipe, inverse_of: :recipe_ingredients
  belongs_to :ingredient

  accepts_nested_attributes_for :ingredient, reject_if: :all_blank, allow_destroy: true

  def ingredient_name
    self.ingredient.name if self.ingredient.present?
  end

  def ingredient_name=(name)
    @ingredient = Ingredient.find_or_create_by(name: name)
    self.ingredient = @ingredient
  end
end
