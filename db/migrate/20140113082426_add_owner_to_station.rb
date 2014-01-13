class AddOwnerToStation < ActiveRecord::Migration
  def change
    add_column :stations, :user_id, :integer

    add_index :stations, :user_id
  end
end
