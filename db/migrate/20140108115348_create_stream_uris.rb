class CreateStreamUris < ActiveRecord::Migration
  def change
    create_table :stream_uris do |t|
      t.references :stream, index: true
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

    add_index :stream_uris, :mime
  end
end
