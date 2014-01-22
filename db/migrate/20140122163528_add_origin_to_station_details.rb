class AddOriginToStationDetails < ActiveRecord::Migration
  def change
    add_column :station_details, :origin, :string
  end
end
