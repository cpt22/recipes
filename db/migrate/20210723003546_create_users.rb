class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.column :access_level, :integer, default: 50
      t.timestamps
    end
  end
end
