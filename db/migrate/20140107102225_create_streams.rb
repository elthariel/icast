class CreateStreams < ActiveRecord::Migration
  def change
    create_table :streams do |t|
      t.string :name
      t.string :slug
      t.text :description

      t.timestamps
    end

    add_index :streams, :slug, unique: true
  end
end
