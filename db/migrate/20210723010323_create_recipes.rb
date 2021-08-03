class CreateRecipes < ActiveRecord::Migration[6.1]
  def change
    create_table :recipes do |t|
      t.string :name, null: false
      t.text :description
      t.text :creator, null: true
      t.references :user, foreign_key: true
      t.datetime :created_at, default: -> {'CURRENT_TIMESTAMP'}
      t.datetime :updated_at, default: -> {'CURRENT_TIMESTAMP'}
    end
  end
end
