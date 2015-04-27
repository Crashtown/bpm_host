class Artist < ActiveRecord::Base
  has_many :albums
  has_many :tracks

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    root 'artists', 'artist'
    expose :id
    expose :name
    expose :albums do |artist, options|
      artist.album_ids
    end
    expose :tracks do |artist, options|
      artist.track_ids
    end
  end
  
  searchable do
    text :name
    integer :id, stored: true
  end
end
