class CreateRecipeIngredients < ActiveRecord::Migration[6.1]
  def change
    create_table :recipe_ingredients do |t|
      t.text :quantity, null: true
      t.text :unit, null: true
      t.references :ingredient, foreign_key: {on_delete: :restrict}, null: false
      t.references :recipe, foreign_key: {on_delete: :cascade}, null: false
    end
  end
end
