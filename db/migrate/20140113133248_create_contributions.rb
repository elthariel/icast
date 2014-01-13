class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.references :user, index: true
      t.string :contributable_type
      t.integer :contributable_id
      t.json :data

      t.datetime :applied_at

      t.timestamps
    end
  end
end
