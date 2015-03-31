class Album < ActiveRecord::Base
  belongs_to :artist
  has_many :tracks

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
