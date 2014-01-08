class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :name
      t.string :slug
      t.text :description

      t.timestamps
    end

    add_index :stations, :slug, unique: true
  end
end
