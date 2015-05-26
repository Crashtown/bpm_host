class Album < ActiveRecord::Base
  belongs_to :artist
  has_many :tracks
  scope :va, -> { where(va: true) }

  serialize :covers, Array

  validates :name, presence: true

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    root 'albums', 'album'
    expose :id
    expose :name
    expose :year
    expose :coverUrl do |album, options|
      'kek'
    end
    expose :artist do |album, options|
      album.artist_id
    end
    expose :tracks do |album, options|
      album.track_ids
    end
  end
  
  searchable do
    text :name
    integer :year
    integer :id, stored: true
  end
end
