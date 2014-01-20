class MoveLogoFromDetailsToStation < ActiveRecord::Migration
  def change
    remove_column :station_details, :logo
    add_column :stations, :logo, :string
  end
end
