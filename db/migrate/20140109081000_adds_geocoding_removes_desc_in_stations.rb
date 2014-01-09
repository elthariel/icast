class AddsGeocodingRemovesDescInStations < ActiveRecord::Migration
  def change
    remove_column :stations, :description

    add_column :stations, :slogan,      :string
    add_column :stations, :longitude,   :decimal, precision: 15, scale: 10
    add_column :stations, :latitude,    :decimal, precision: 15, scale: 10
    add_column :stations, :country,     :string,  length: 2
    add_column :stations, :language,    :string,  length: 2

    add_index :stations, :country
    add_index :stations, :language
  end
end
