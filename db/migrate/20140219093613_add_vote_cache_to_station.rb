class AddVoteCacheToStation < ActiveRecord::Migration
  def change
    add_column  :stations, :cached_votes_up, :integer, default: 0
    add_index   :stations, :cached_votes_up
  end
end
