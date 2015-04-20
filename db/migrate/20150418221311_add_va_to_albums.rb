class AddVaToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :va, :boolean, default: false
  end
end
