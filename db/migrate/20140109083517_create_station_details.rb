class CreateStationDetails < ActiveRecord::Migration
  def change
    create_table :station_details do |t|
      t.references :station

      t.string  :state
      t.string  :city

      t.string  :website
      t.string  :email
      t.string  :twitter
      t.string  :phone
      t.string  :logo
      t.text    :description
      t.text    :lineup

      t.timestamps
    end
  end
end
