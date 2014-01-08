class CreateStreams < ActiveRecord::Migration
  def change
    create_table :streams do |t|
      t.references :station, index: true
      t.string     :uri
      t.boolean    :video, default: false
      t.string     :mime
      t.integer    :bitrate

      t.integer    :samplerate
      t.integer    :channels
      t.integer    :framerate   # Only for video
      t.integer    :width       # Only for video
      t.integer    :height      # Only for video

      t.timestamps
    end

    add_index :streams, :mime
  end
end
