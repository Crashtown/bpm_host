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
  end
end
