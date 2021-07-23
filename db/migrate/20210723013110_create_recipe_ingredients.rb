class CreateRecipeIngredients < ActiveRecord::Migration[6.1]
  def change
    create_table :recipe_ingredients do |t|
      t.text :quantity, null: false, default: "1"
      t.text :unit, null: false
      t.references :ingredient, foreign_key: true
      t.references :recipe, foreign_key: true
      t.index [:ingredient_id, :recipe_id], unique: true
    end
  end
end
