class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :name
      t.integer :year
      t.string :cover
      t.references :artist, index: true

      t.timestamps null: false
    end
    add_foreign_key :albums, :artists
  end
end
