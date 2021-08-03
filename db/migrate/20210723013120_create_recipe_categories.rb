class CreateRecipeCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :recipe_categories do |t|
      t.references :recipe, foreign_key: {on_delete: :cascade}
      t.references :category, foreign_key: {on_delete: :restrict}
      t.index [:recipe_id, :category_id], unique: true
    end
  end
end
