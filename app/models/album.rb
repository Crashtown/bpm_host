class Album < ActiveRecord::Base
  belongs_to :artist
  has_many :tracks
  scope :va, -> { where(va: true) }

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
  end
end
