class AddHowCreatedFieldToRecipes < ActiveRecord::Migration[6.1]
  def change
    add_column :recipes, :imported, :boolean, default: false
  end
end
