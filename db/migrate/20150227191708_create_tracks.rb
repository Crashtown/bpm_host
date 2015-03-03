class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.references :album, index: true
      t.references :artist, index: true
      t.string :filepath
      t.string :album_tag
      t.string :artist_tag
      t.integer :track_number_tag
      t.string :title_tag
      t.integer :year_tag
      t.string :genre_tag

      t.timestamps null: false
    end
    add_foreign_key :tracks, :albums
    add_foreign_key :tracks, :artists
  end
end
