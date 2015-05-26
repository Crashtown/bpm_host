class AddFilePathAndCoversToAlbums < ActiveRecord::Migration
  def up
    add_column :albums, :filepath, :string
    rename_column :albums, :cover, :covers
  end

  def down
    remove_column :albums, :filepath
    rename_column :albums, :covers, :cover
  end
end
