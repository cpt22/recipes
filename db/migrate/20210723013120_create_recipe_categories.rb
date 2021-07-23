class CreateRecipeCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :recipe_categories do |t|
      t.references :recipe, foreign_key: true
      t.references :category, foreign_key: true
      t.index [:recipe_id, :category_id], unique: true
    end
  end
end
